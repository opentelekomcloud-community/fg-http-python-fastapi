##########################################################
# code bucket
##########################################################
resource "opentelekomcloud_obs_bucket" "codebucket" {
  bucket = replace(format("%s-%s", var.prefix, "codebucket"), "_", "-")
  acl    = "private"
}

##########################################################
# create zip file
##########################################################
resource "null_resource" "createZip" {
  provisioner "local-exec" {
    command     = "python3 createZip.py"
    working_dir = "${path.root}/.."
  }
  triggers = {
    always_run = "${timestamp()}"
  }

}


##########################################################
# upload zip file to bucket
##########################################################
resource "opentelekomcloud_obs_bucket_object" "code_object" {
  bucket = opentelekomcloud_obs_bucket.codebucket.bucket
  key    = format("%s/%s", "code", var.zip_file_name)
  source = format("${path.root}/../%s", var.zip_file_name)
  etag   = filemd5(format("${path.root}/../%s", var.zip_file_name))
}

##########################################################
# store md5 of zip file in state
##########################################################
resource "terraform_data" "replacement" {
  input = [
    filemd5(format("${path.root}/../%s", var.zip_file_name))
  ]
}

##########################################################
# opentelekomcloud_fgs_function_v2.function
##########################################################
resource "opentelekomcloud_fgs_function_v2" "function" {
  depends_on = [opentelekomcloud_obs_bucket_object.code_object]

  name = format("%s_%s", var.prefix, var.function_name)
  app  = "default"
  #  agency      = var.agency_name
  handler          = "index.handler"
  memory_size      = 128
  timeout          = 30
  max_instance_num = 400

  runtime = "http"

  code_type     = "obs"
  code_url      = format("https://%s/code/%s", opentelekomcloud_obs_bucket.codebucket.bucket_domain_name, var.zip_file_name)
  code_filename = var.zip_file_name

  log_group_id   = opentelekomcloud_lts_group_v2.FunctionLogGroup.id
  log_group_name = opentelekomcloud_lts_group_v2.FunctionLogGroup.group_name

  log_topic_id   = opentelekomcloud_lts_stream_v2.FunctionLogStream.id
  log_topic_name = opentelekomcloud_lts_stream_v2.FunctionLogStream.stream_name

  lifecycle {
    # replace if code in bucket changed
    replace_triggered_by = [
      terraform_data.replacement
    ]
  }

  reserved_instances {
    count          = 1
    qualifier_name = "latest"
    qualifier_type = "version"
  }

}

##########################################################
# opentelekomcloud_apigw_group_v2.group
##########################################################
resource "opentelekomcloud_apigw_group_v2" "group1" {
  name        = format("%s_%s", var.prefix, "group1")
  instance_id = opentelekomcloud_apigw_gateway_v2.gateway.id
  description = format("API Group for %s", var.prefix)
}

##########################################################
# opentelekomcloud_apigw_api_v2.api1
##########################################################
resource "opentelekomcloud_apigw_api_v2" "api1" {
  gateway_id                   = opentelekomcloud_apigw_gateway_v2.gateway.id
  group_id                     = opentelekomcloud_apigw_group_v2.group1.id
  name                         = format("%s_%s", var.prefix, "api1")
  type                         = "Public"
  request_protocol             = "HTTP"
  request_method               = "ANY"
  request_uri                  = "/"
  security_authentication_type = "NONE"
  match_mode                   = "PREFIX"
  success_response             = "Success response"
  failure_response             = "Failed response"
  description                  = format("Created by script for %s", var.prefix)

  func_graph {
    function_urn    = opentelekomcloud_fgs_function_v2.function.urn
    version         = "latest"
    timeout         = 5000
    invocation_type = "sync"
    network_type    = "NON-VPC"
  }

}

###########################################################
# random_id.trigger_replacer
###########################################################
resource "random_id" "trigger_replacer" {
  keepers = {
    # change to force new resource on each deploy
    timestamp = timestamp()
  }
  byte_length = 8
}

##########################################################
# opentelekomcloud_fgs_trigger_v2.apig1
##########################################################
resource "opentelekomcloud_fgs_trigger_v2" "apig1" {
  function_urn = opentelekomcloud_fgs_function_v2.function.urn
  type         = "DEDICATEDGATEWAY"
  status       = "ACTIVE"

  lifecycle {
    replace_triggered_by = [random_id.trigger_replacer]
  }

  event_data = jsonencode({
    "name"       = format("%s_%s", var.prefix, "api1") #trigger_1
    "type"       = 1
    "path"       = "/"
    "protocol"   = "HTTPS"
    "req_method" = "ANY"
    "group_id"   = opentelekomcloud_apigw_group_v2.group1.id
    "group_name" = opentelekomcloud_apigw_group_v2.group1.name
    "match_mode" = "SWA"
    "env_name"   = "RELEASE"                        #opentelekomcloud_apigw_environment_v2.env.name
    "env_id"     = "DEFAULT_ENVIRONMENT_RELEASE_ID" #opentelekomcloud_apigw_environment_v2.env.id
    "auth"       = "NONE"
    "func_info" = {
      "function_urn"    = opentelekomcloud_fgs_function_v2.function.urn
      "invocation_type" = "sync"
      "timeout"         = 5000
      "version"         = "latest"
    }
    "sl_domain"    = format("https://%s.apic.%s.otc.t-systems.com/", opentelekomcloud_apigw_group_v2.group1.id, var.OTC_SDK_REGION)
    "backend_type" = "FUNCTION"
    "instance_id"  = opentelekomcloud_apigw_gateway_v2.gateway.id

  })
}

##########################################################
# opentelekomcloud_lts_group_v2.FunctionLogGroup  
##########################################################
resource "opentelekomcloud_lts_group_v2" "FunctionLogGroup" {
  group_name  = format("%s_%s_%s", var.prefix, var.function_name, "log_group")
  ttl_in_days = 1

}

##########################################################
# opentelekomcloud_lts_stream_v2.FunctionLogStream
##########################################################
resource "opentelekomcloud_lts_stream_v2" "FunctionLogStream" {
  group_id    = opentelekomcloud_lts_group_v2.FunctionLogGroup.id
  stream_name = format("%s_%s_%s", var.prefix, var.function_name, "log_stream")
}


