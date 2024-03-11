// Parameters
@description('Specifies the name of the Azure Front Door.')
param frontDoorName string

@description('The name of the SKU to use when creating the Front Door profile.')
@allowed([
  'Standard_AzureFrontDoor'
  'Premium_AzureFrontDoor'
])
param frontDoorSkuName string = 'Premium_AzureFrontDoor'

@description('Specifies the send and receive timeout on forwarding request to the origin. When timeout is reached, the request fails and returns.')
param originResponseTimeoutSeconds int = 30

@description('Specifies the name of the Azure Front Door Origin Group for the web application.')
param originGroupName string

@description('Specifies the name of the Azure Front Door Origin for the web application.')
param originName string

@description('Specifies the address of the origin. Domain names, IPv4 addresses, and IPv6 addresses are supported.This should be unique across all origins in an endpoint.')
param hostName string

@description('Specifies the value of the HTTP port. Must be between 1 and 65535.')
param httpPort int = 80

@description('Specifies the value of the HTTPS port. Must be between 1 and 65535.')
param httpsPort int = 443

@description('Specifies the host header value sent to the origin with each request. If you leave this blank, the request hostname determines this value. Azure Front Door origins, such as Web Apps, Blob Storage, and Cloud Services require this host header value to match the origin hostname by default. This overrides the host header defined at Endpoint.')
param originHostHeader string

@description('Specifies the priority of origin in given origin group for load balancing. Higher priorities will not be used for load balancing if any lower priority origin is healthy.Must be between 1 and 5.')
@minValue(1)
@maxValue(5)
param priority int = 1

@description('Specifies the weight of the origin in a given origin group for load balancing. Must be between 1 and 1000.')
@minValue(1)
@maxValue(1000)
param weight int = 1000

@description('Specifies whether to enable health probes to be made against backends defined under backendPools. Health probes can only be disabled if there is a single enabled backend in single enabled backend pool.')
@allowed([
  'Enabled'
  'Disabled'
])
param originEnabledState string = 'Enabled'

@description('Specifies the resource id of a private link service.')
param privateLinkResourceId string

@description('Specifies the number of samples to consider for load balancing decisions.')
param sampleSize int = 4

@description('Specifies the number of samples within the sample period that must succeed.')
param successfulSamplesRequired int = 3

@description('Specifies the additional latency in milliseconds for probes to fall into the lowest latency bucket.')
param additionalLatencyInMilliseconds int = 50

@description('Specifies path relative to the origin that is used to determine the health of the origin.')
param probePath string = '/'

@description('The custom domain name to associate with your Front Door endpoint.')
param customDomainName string

@description('Specifies the health probe request type.')
@allowed([
  'GET'
  'HEAD'
  'NotSet'
])
param probeRequestType string = 'GET'

@description('Specifies the health probe protocol.')
@allowed([
  'Http'
  'Https'
  'NotSet'
])
param probeProtocol string = 'Http'

@description('Specifies the number of seconds between health probes.Default is 240 seconds.')
param probeIntervalInSeconds int = 60

@description('Specifies whether to allow session affinity on this host. Valid options are Enabled or Disabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param sessionAffinityState string = 'Disabled'

@description('Specifies the endpoint name reuse scope. The default value is TenantReuse.')
@allowed([
  'NoReuse'
  'ResourceGroupReuse'
  'SubscriptionReuse'
  'TenantReuse'
])
param autoGeneratedDomainNameLabelScope string = 'TenantReuse'

@description('Specifies the name of the Azure Front Door Route for the web application.')
param routeName string

@description('Specifies a directory path on the origin that Azure Front Door can use to retrieve content from, e.g. contoso.cloudapp.net/originpath.')
param originPath string = '/'

@description('Specifies the rule sets referenced by this endpoint.')
param ruleSets array = []

@description('Specifies the list of supported protocols for this route')
param supportedProtocols array  = [
  'Http'
  'Https'
]

@description('Specifies the route patterns of the rule.')
param routePatternsToMatch array = [ '/*' ]

@description('Specifies the protocol this rule will use when forwarding traffic to backends.')
@allowed([
  'HttpOnly'
  'HttpsOnly'
  'MatchRequest'
])
param forwardingProtocol string = 'HttpsOnly'

@description('Specifies whether this route will be linked to the default endpoint domain.')
@allowed([
  'Enabled'
  'Disabled'
])
param linkToDefaultDomain string = 'Enabled'

@description('Specifies whether to automatically redirect HTTP traffic to HTTPS traffic. Note that this is a easy way to set up this rule and it will be the first rule that gets executed.')
@allowed([
  'Enabled'
  'Disabled'
])
param httpsRedirect string = 'Enabled'

@description('Specifies the name of the Azure Front Door Endpoint for the web application.')
param endpointName string

@description('Specifies whether to enable use of this rule. Permitted values are Enabled or Disabled')
@allowed([
  'Enabled'
  'Disabled'
])
param endpointEnabledState string = 'Enabled'

@description('Specifies the name of the Azure Front Door WAF policy.')
param wafPolicyName string

@description('Specifies the WAF policy is in detection mode or prevention mode.')
@allowed([
  'Detection'
  'Prevention'
])
param wafPolicyMode string = 'Prevention'

@description('Specifies if the policy is in enabled or disabled state. Defaults to Enabled if not specified.')
param wafPolicyEnabledState string = 'Enabled'

@description('Specifies the list of managed rule sets to configure on the WAF.')
param wafManagedRuleSets array = []

@description('Specifies the list of custom rulesto configure on the WAF.')
param wafCustomRules array = []

@description('Specifies if the WAF policy managed rules will inspect the request body content.')
@allowed([
  'Enabled'
  'Disabled'
])
param wafPolicyRequestBodyCheck string = 'Enabled'

@description('Specifies name of the security policy.')
param securityPolicyName string

@description('Specifies the list of patterns to match by the security policy.')
param securityPolicyPatternsToMatch array = [ '/*' ]

@description('Specifies the resource id of the Log Analytics workspace.')
param workspaceId string

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object

@description('Specifies the name of the resource group that contains the key vault with custom domain\'s certificate.')
param keyVaultResourceGroupName string = resourceGroup().name

@description('Specifies the name of the Key Vault that contains the custom domain certificate.')
param keyVaultName string

@description('Specifies the name of the Key Vault secret that contains the custom domain certificate.')
param keyVaultCertificateName string

@description('Specifies the version of the Key Vault secret that contains the custom domain certificate. Set the value to an empty string to use the latest version.')
param keyVaultCertificateVersion string = ''

@description('Specifies the TLS protocol version that will be used for Https')
param minimumTlsVersion string = 'TLS12'

// Variables
var diagnosticSettingsName = 'diagnosticSettings'
var logCategories = [
  'FrontDoorAccessLog'
  'FrontDoorHealthProbeLog'
  'FrontDoorWebApplicationFirewallLog'
]
var metricCategories = [
  'AllMetrics'
]
var logs = [for category in logCategories: {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: 0
  }
}]
var metrics = [for category in metricCategories: {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: 0
  }
}]

// Resources
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  scope: resourceGroup(keyVaultResourceGroupName)
  name: keyVaultName

  resource secret 'secrets' existing = {
    name: keyVaultCertificateName
  }
}

resource frontDoor 'Microsoft.Cdn/profiles@2022-11-01-preview' = {
  name: frontDoorName
  location: 'Global'
  tags: tags
  sku: {
    name: frontDoorSkuName
  }
  properties: {
    originResponseTimeoutSeconds: originResponseTimeoutSeconds
  }
}

resource originGroup 'Microsoft.Cdn/profiles/origingroups@2022-11-01-preview' = {
  parent: frontDoor
  name: originGroupName
  properties: {
    loadBalancingSettings: {
      sampleSize: sampleSize
      successfulSamplesRequired: successfulSamplesRequired
      additionalLatencyInMilliseconds: additionalLatencyInMilliseconds
    }
    healthProbeSettings: {
      probePath: probePath
      probeRequestType: probeRequestType
      probeProtocol: probeProtocol
      probeIntervalInSeconds: probeIntervalInSeconds
    }
    sessionAffinityState: sessionAffinityState
  }
}

resource origin 'Microsoft.Cdn/profiles/origingroups/origins@2022-11-01-preview' = {
  parent: originGroup
  name: originName
  properties: {
    hostName: hostName
    httpPort: httpPort
    httpsPort: httpsPort
    originHostHeader: originHostHeader
    priority: priority
    weight: weight
    enabledState: originEnabledState
    sharedPrivateLinkResource: empty(privateLinkResourceId) ? {} : {
      privateLink: {
        id: privateLinkResourceId
      }
      privateLinkLocation: location
      status: 'Approved'
      requestMessage: 'Please approve this request to allow Front Door to access the container app'
    }
    enforceCertificateNameCheck: true
  }
}

resource endpoint 'Microsoft.Cdn/profiles/afdEndpoints@2022-11-01-preview' = {
  parent: frontDoor
  name: endpointName
  location: 'Global'
  properties: {
    autoGeneratedDomainNameLabelScope: toUpper(autoGeneratedDomainNameLabelScope)
    enabledState: endpointEnabledState
  }
}

resource route 'Microsoft.Cdn/profiles/afdEndpoints/routes@2022-11-01-preview' = {
  parent: endpoint
  name: routeName
  properties: {
    customDomains: [
      {
        id: customDomain.id
      }
    ]
    originGroup: {
      id: originGroup.id
    }
    originPath: originPath
    ruleSets: ruleSets
    supportedProtocols: supportedProtocols
    patternsToMatch: routePatternsToMatch
    forwardingProtocol: forwardingProtocol
    linkToDefaultDomain: linkToDefaultDomain
    httpsRedirect: httpsRedirect
  }
  dependsOn: [
    origin
  ]
}

resource secret 'Microsoft.Cdn/profiles/secrets@2023-07-01-preview' = {
  name: toLower(format('{0}-{1}-latest', keyVaultName, keyVaultCertificateName))
  parent: frontDoor
  properties: {
    parameters: {
      type: 'CustomerCertificate'
      useLatestVersion: (keyVaultCertificateVersion == '')
      secretVersion: keyVaultCertificateVersion
      secretSource: {
        id: keyVault::secret.id
      }
    }
  }
}

resource customDomain 'Microsoft.Cdn/profiles/customDomains@2023-07-01-preview' = {
  name: replace(customDomainName, '.', '-')
  parent: frontDoor
  properties: {
    hostName: customDomainName
    tlsSettings: {
      certificateType: 'CustomerCertificate'
      minimumTlsVersion: minimumTlsVersion
      secret: {
        id: secret.id
      }
    }
  }
}

resource wafPolicy 'Microsoft.Network/FrontDoorWebApplicationFirewallPolicies@2022-05-01' = {
  name: wafPolicyName
  location: 'Global'
  tags: tags
  sku: {
    name: frontDoorSkuName
  }
  properties: {
    policySettings: {
      enabledState: wafPolicyEnabledState
      mode: wafPolicyMode
      requestBodyCheck: wafPolicyRequestBodyCheck
    }
    managedRules: {
      managedRuleSets: wafManagedRuleSets
    }
    customRules: {
      rules: wafCustomRules
    }
  }
}

resource securityPolicy 'Microsoft.Cdn/profiles/securitypolicies@2022-11-01-preview' = {
  parent: frontDoor
  name: securityPolicyName
  properties: {
    parameters: {
      type: 'WebApplicationFirewall'
      wafPolicy: {
        id: wafPolicy.id
      }
      associations: [
        {
          domains: [
            {
              id: endpoint.id
            }
            {
              id: customDomain.id
            }
          ]
          patternsToMatch: securityPolicyPatternsToMatch
        }
      ]

    }
  }
}

// Diagnostics Settings
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingsName
  scope: frontDoor
  properties: {
    workspaceId: workspaceId
    logs: logs
    metrics: metrics
  }
}

// Outputs
output id string = frontDoor.id
output name string = frontDoor.name
output frontDoorEndpointFqdn string = endpoint.properties.hostName
output customDomainValidationDnsTxtRecordValue string = customDomain.properties.validationProperties.validationToken != null ? customDomain.properties.validationProperties.validationToken : ''
output customDomainValidationExpiry string = customDomain.properties.validationProperties.expirationDate
output customDomainDeploymentStatus string = customDomain.properties.deploymentStatus
output customDomainValidationState string = customDomain.properties.domainValidationState
