##########################################################
# Output the URL of the deployed API
##########################################################
output "URL" {
  value = format("https://%s.apic.%s.otc.t-systems.com",
  opentelekomcloud_apigw_group_v2.group1.id, var.OTC_SDK_REGION)
}

output "URL_Root" {
  value = format("https://%s.apic.%s.otc.t-systems.com/",
  opentelekomcloud_apigw_group_v2.group1.id, var.OTC_SDK_REGION)
}

output "URL_APIItems" {
  value = format("https://%s.apic.%s.otc.t-systems.com/api/items/100",
  opentelekomcloud_apigw_group_v2.group1.id, var.OTC_SDK_REGION)
}

output "URL_docs" {
  value = format("https://%s.apic.%s.otc.t-systems.com/docs",
  opentelekomcloud_apigw_group_v2.group1.id, var.OTC_SDK_REGION)
}

output "URL_redocs" {
  value = format("https://%s.apic.%s.otc.t-systems.com/redoc",
  opentelekomcloud_apigw_group_v2.group1.id, var.OTC_SDK_REGION)
}

output "URL_openapi" {
  value = format("https://%s.apic.%s.otc.t-systems.com/openapi.json",
  opentelekomcloud_apigw_group_v2.group1.id, var.OTC_SDK_REGION)
}
