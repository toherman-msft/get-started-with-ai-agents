metadata description = 'Creates or updates an existing Azure Container App.'
param name string
param location string = resourceGroup().location
param tags object = {}

@description('The environment name for the container apps')
param containerAppsEnvironmentName string

@description('The number of CPU cores allocated to a single container instance, e.g., 0.5')
param containerCpuCoreCount string = '0.5'

@description('The maximum number of replicas to run. Must be at least 1.')
@minValue(1)
param containerMaxReplicas int = 10

@description('The amount of memory allocated to a single container instance, e.g., 1Gi')
param containerMemory string = '1.0Gi'

@description('The minimum number of replicas to run. Must be at least 1.')
@minValue(1)
param containerMinReplicas int = 1

@description('The name of the container')
param containerName string = 'main'

@allowed([ 'http', 'grpc' ])
@description('The protocol used by Dapr to connect to the app, e.g., HTTP or gRPC')
param daprAppProtocol string = 'http'

@description('Enable or disable Dapr for the container app')
param daprEnabled bool = false

@description('The Dapr app ID')
param daprAppId string = containerName

@description('Specifies if Ingress is enabled for the container app')
param ingressEnabled bool = true

@description('The type of identity for the resource')
@allowed([ 'None', 'SystemAssigned', 'UserAssigned' ])
param identityType string = 'None'

@description('The name of the user-assigned identity')
param identityName string = ''

@description('The secrets required for the container')
@secure()
param secrets object = {}

@description('The environment variables for the container')
param env array = []

@description('Specifies if the resource ingress is exposed externally')
param external bool = true

@description('The service binds associated with the container')
param serviceBinds array = []

@description('The target port for the container')
param targetPort int = 80

param projectName string


module app 'container-app.bicep' = {
  name: '${deployment().name}-update'
  params: {
    name: name
    location: location
    tags: tags
    identityType: identityType
    identityName: identityName
    ingressEnabled: ingressEnabled
    containerName: containerName
    containerAppsEnvironmentName: containerAppsEnvironmentName
    containerCpuCoreCount: containerCpuCoreCount
    containerMemory: containerMemory
    containerMinReplicas: containerMinReplicas
    containerMaxReplicas: containerMaxReplicas
    daprEnabled: daprEnabled
    daprAppId: daprAppId
    daprAppProtocol: daprAppProtocol
    secrets: secrets
    external: external
    env: env
    targetPort: targetPort
    serviceBinds: serviceBinds
    dependOn: projectName
  }
}

output defaultDomain string = app.outputs.defaultDomain
output name string = app.outputs.name
output uri string = app.outputs.uri
