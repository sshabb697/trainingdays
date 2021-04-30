@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd3'

@description('Resource tags object to use')
param resourceTag object

var storageAccountName = 'stfe${env}${take(uniqueString(resourceGroup().id), 11)}'
var location = resourceGroup().location

var appiName = 'appi-scm-${env}-${uniqueString(resourceGroup().id)}'
var contactsApiName = 'app-contactsapi-${env}-${uniqueString(resourceGroup().id)}'
var resourcesApiName = 'app-resourcesapi-${env}-${uniqueString(resourceGroup().id)}'
var searchApiName = 'app-searchapi-${env}-${uniqueString(resourceGroup().id)}'

resource appi 'Microsoft.Insights/components@2015-05-01' existing = {
  name: appiName
}

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  tags: resourceTag
  kind: 'StorageV2'
  sku: {
    name:'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
  }
}

output applicationInsightsKey string = appi.properties.InstrumentationKey
output contactsApiEndpoint string = 'https://${contactsApiName}.azurewebsites.net'
output resourcesApiEndpoint string = 'https://${resourcesApiName}.azurewebsites.net'
output searchApiEndpoint string = 'https://${searchApiName}.azurewebsites.net'
output storageAccountName string = storageAccountName
output storageAccountWebEndpoint string = stg.properties.primaryEndpoints.web
