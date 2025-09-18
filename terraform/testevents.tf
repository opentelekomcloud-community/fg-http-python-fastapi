##########################################################
# Test events for FastAPI function to be used in
# OpenTelekomCloud FunctionGraph console
##########################################################

##########################################################
# Test event for /
##########################################################
resource "opentelekomcloud_fgs_event_v2" "event_root" {
  function_urn = opentelekomcloud_fgs_function_v2.function.urn
  name         = "root"
  content = base64encode(jsonencode({
    body                  = ""
    requestContext        = {}
    queryStringParameters = { "responseType" : "html" }
    httpMethod            = "GET"
    pathParameters        = {}
    headers               = {}
    path                  = "/"
    isBase64Encoded       = true
  }))
}

##########################################################
# Test event for /api/items/100?q=20
##########################################################
resource "opentelekomcloud_fgs_event_v2" "event_items" {
  function_urn = opentelekomcloud_fgs_function_v2.function.urn
  name         = "items"
  content = base64encode(jsonencode({
    body                  = ""
    requestContext        = {}
    queryStringParameters = { "q" : "20" }
    httpMethod            = "GET"
    pathParameters        = {}
    headers               = {}
    path                  = "/api/items/100"
    isBase64Encoded       = true
  }))
}

##########################################################
# Test event for /docs
##########################################################
resource "opentelekomcloud_fgs_event_v2" "event_docs" {
  function_urn = opentelekomcloud_fgs_function_v2.function.urn
  name         = "docs"
  content = base64encode(jsonencode({
    body                  = ""
    requestContext        = {}
    queryStringParameters = {}
    httpMethod            = "GET"
    pathParameters        = {}
    headers               = {}
    path                  = "/docs"
    isBase64Encoded       = true
  }))
}

##########################################################
# Test event for /redoc 
##########################################################
resource "opentelekomcloud_fgs_event_v2" "event_redocs" {
  function_urn = opentelekomcloud_fgs_function_v2.function.urn
  name         = "redocs"
  content = base64encode(jsonencode({
    body                  = ""
    requestContext        = {}
    queryStringParameters = {}
    httpMethod            = "GET"
    pathParameters        = {}
    headers               = {}
    path                  = "/redoc"
    isBase64Encoded       = true
  }))
}

##########################################################
# Test event for /openapi.json
##########################################################
resource "opentelekomcloud_fgs_event_v2" "event_openapi" {
  function_urn = opentelekomcloud_fgs_function_v2.function.urn
  name         = "openapi"
  content = base64encode(jsonencode({
    body                  = ""
    requestContext        = {}
    queryStringParameters = {}
    httpMethod            = "GET"
    pathParameters        = {}
    headers               = {}
    path                  = "/openapi.json"
    isBase64Encoded       = true
  }))
}