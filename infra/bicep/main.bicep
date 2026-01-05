
// FSI Bootcamp Secure Baseline (v2)
param location string = resourceGroup().location
param namePrefix string = 'fsiBootcamp'
param logAnalyticsSku string = 'PerGB2018'

// Log Analytics
resource law 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: '${namePrefix}-log'
  location: location
  properties: { sku: { name: logAnalyticsSku } }
}

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: '${namePrefix}-vnet'
  location: location
  properties: {
    addressSpace: { addressPrefixes: [ '10.10.0.0/16' ] }
    subnets: [
      {
        name: 'apim-subnet'
        properties: { addressPrefix: '10.10.1.0/24' }
      },
      {
        name: 'containerapps-subnet'
        properties: { addressPrefix: '10.10.2.0/24' }
      },
      {
        name: 'private-endpoints'
        properties: {
          addressPrefix: '10.10.3.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

// Key Vault
resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: '${namePrefix}-kv'
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: { name: 'standard', family: 'A' }
    enabledForDeployment: true
    enableRbacAuthorization: true
  }
}

// API Management (Developer tier; integrate with VNET via subnet)
resource apim 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: '${namePrefix}-apim'
  location: location
  sku: { name: 'Developer', capacity: 1 }
  properties: {
    publisherName: 'Bootcamp'
    publisherEmail: 'bootcamp@example.com'
    virtualNetworkType: 'External'
    // NOTE: APIM VNET requires the subnet resource id. Fill after deployment if needed.
  }
}

// Container Apps Environment (VNET integrated)
resource cae 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: '${namePrefix}-cae'
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: { customerId: law.properties.customerId, sharedKey: 'REPLACE' }
    }
    vnetConfiguration: {
      infrastructureSubnetId: vnet::subnets[1].id // containerapps-subnet
    }
  }
}

// Private DNS zones (placeholders)
resource privDnsKv 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: 'privatelink.vaultcore.azure.net'
}
resource privDnsApim 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: 'privatelink.azure-api.net'
}

// Private Endpoints
resource peKv 'Microsoft.Network/privateEndpoints@2022-07-01' = {
  name: '${namePrefix}-pe-kv'
  location: location
  properties: {
    subnet: { id: vnet::subnets[2].id }
    privateLinkServiceConnections: [{
      name: 'kv-pls'
      properties: {
        privateLinkServiceId: kv.id
        groupIds: ['vault']
      }
    }]
  }
}
resource peApim 'Microsoft.Network/privateEndpoints@2022-07-01' = {
  name: '${namePrefix}-pe-apim'
  location: location
  properties: {
    subnet: { id: vnet::subnets[2].id }
    privateLinkServiceConnections: [{
      name: 'apim-pls'
      properties: {
        privateLinkServiceId: apim.id
        groupIds: ['gateway']
      }
    }]
  }
}

// Diagnostic settings to Log Analytics
resource diagKv 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'kv-diag'
  scope: kv
  properties: {
    workspaceId: law.id
    logs: [ { category: 'AuditEvent', enabled: true } ]
  }
}
resource diagApim 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'apim-diag'
  scope: apim
  properties: {
    workspaceId: law.id
    logs: [
      { category: 'GatewayLogs', enabled: true },
      { category: 'WebSocketConnectionsLogs', enabled: true },
      { category: 'DeveloperPortal', enabled: true }
    ]
    metrics: [ { category: 'AllMetrics', enabled: true } ]
  }
}
resource diagCae 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'cae-diag'
  scope: cae
  properties: {
    workspaceId: law.id
    logs: [ { category: 'SystemLogs', enabled: true } ]
  }
}

// APIM Global Policy (rate limits + tracing + CORS)
resource apimPolicy 'Microsoft.ApiManagement/service/policies@2022-08-01' = {
  name: '${apim.name}/policy'
  properties: {
    value: '''
    <policies>
      <inbound>
        <rate-limit calls="60" renewal-period="60" />
        <set-header name="x-correlation-id" exists-action="override">
          <value>@(Guid.NewGuid().ToString())</value>
        </set-header>
        <cors allow-credentials="false">
          <allowed-origins>
            <origin>*</origin>
          </allowed-origins>
          <allowed-methods>
            <method>GET</method>
            <method>POST</method>
          </allowed-methods>
          <allowed-headers>
            <header>*</header>
          </allowed-headers>
        </cors>
      </inbound>
      <backend>
        <forward-request />
      </backend>
      <outbound>
        <set-header name="x-api-managed" exists-action="override">
          <value>apim</value>
        </set-header>
      </outbound>
      <on-error>
        <return-response>
          <set-status code="500" reason="API Error" />
          <set-body>Internal error</set-body>
        </return-response>
      </on-error>
    </policies>
    '''
    format: 'xml'
  }
}

// Example APIM API pointing to FastAPI (replace serviceUrl)
resource api 'Microsoft.ApiManagement/service/apis@2022-08-01' = {
  name: '${apim.name}/fsi-api'
  properties: {
    path: 'fsi'
    protocols: [ 'https' ]
    serviceUrl: 'https://REPLACE_FASTAPI_HOST' // e.g., Container Apps app URL or App Service
    apiType: 'http'
    displayName: 'FSI Bootcamp API'
  }
}

resource op1 'Microsoft.ApiManagement/service/apis/operations@2022-08-01' = {
  name: '${apim.name}/fsi-api/cm-signal'
  properties: {
    displayName: 'CapitalMarketsSignal'
    method: 'POST'
    urlTemplate: '/capital-markets/signal'
    templateParameters: []
    responses: [ { statusCode: 200 } ]
    request: { queryParameters: [], headers: [] }
  }
  dependsOn: [ api ]
}

// Attach API-level policy to enforce per-operation quotas
resource apiPolicy 'Microsoft.ApiManagement/service/apis/policies@2022-08-01' = {
  name: '${apim.name}/fsi-api/policy'
  properties: {
    value: '''
    <policies>
      <inbound>
        <rate-limit-by-key calls="30" renewal-period="60" counter-key="@(context.Request.IpAddress)" />
        <set-header name="x-api-version" exists-action="override">
          <value>v1</value>
        </set-header>
      </inbound>
      <backend>
        <forward-request />
      </backend>
      <outbound />
      <on-error />
    </policies>
    '''
    format: 'xml'
  }
  dependsOn: [ api ]
}
