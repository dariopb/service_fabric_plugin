# Traefik service-fabric-plugin

This provider plugin allows Traefik to query the Service Fabric management API to discover what services are currently running on a Service Fabric cluster. The provider then maps routing rules to these service instances. The provider will take into account the Health and Status of each of the services to ensure requests are only routed to healthy service instances.
* **This is a community/unofficial implementation in development**

## Installation
The plugin needs to be configured in the Traefik static configuration before it can be used.

## Configuration
The plugin currently supports the following configuration settings:
* **pollInterval:**          The interval for polling the management endpoint for changes, in seconds.
* **clusterManagementURL:**  The URL for the Service Fabric Management API endpoint (e.g. `http://dariotraefik1.southcentralus.cloudapp.azure.com:19080/`)
* **certificate:**           The path to a certificate file or the PEM certificate content. If not provided, HTTP will be used.
* **certificateKey:**        The path to a private key file or the key content. If not provided, HTTP will be used.

## Example configuration

```yaml
entryPoints:
  web:
    address: :9999
    
api:
  dashboard: true

log:
  level: DEBUG

pilot:
  token: xxxxx

experimental:
  traefikServiceFabricPlugin:
    moduleName: github.com/dariopb/traefikServiceFabricPlugin
    version: v0.2.2

providers:
  plugin:
    traefikServiceFabricPlugin:
      pollInterval: 4s
      clusterManagementURL: http://dariotraefik1.southcentralus.cloudapp.azure.com:19080/
      #certificate : ./cert.pem
      #certificateKey: ./cert.key
```

## Sample deployments
For a complete way to deploy and use the proxy in a Service Fabric cluster, please look here: https://github.com/dariopb/sf-reverseproxies-templates (those are **samples** only and should be modified according to your needs)

### ServiceManifest file
This is a sample SF enabled service showing the currently supported labels. If the sf name is fabric:/pinger/PingerService, the endpoint will be expose at that prefix: '/pinger/PingerService/'
```xml
  ...
  <ServiceTypes>
    <StatelessServiceType ServiceTypeName="PingerServiceType" UseImplicitHost="true">
      <Extensions>
        <Extension Name="traefik">
        <Labels xmlns="http://schemas.microsoft.com/2015/03/fabact-no-schema">
          <Label Key="traefik.http.enable">true</Label>
          <Label Key="traefik.http.entrypoints">web</Label>
          <Label Key="traefik.http.loadbalancer.passhostheader">true</Label>
          <Label Key="traefik.http.loadbalancer.healthcheck.path">/</Label>
          <Label Key="traefik.http.loadbalancer.healthcheck.interval">10s</Label>
          <Label Key="traefik.http.loadbalancer.healthcheck.scheme">http</Label>
          <Label Key="traefik.http.loadbalancer.stickiness">true</Label>
          <Label Key="traefik.http.loadbalancer.stickiness.secure">true</Label>
          <Label Key="traefik.http.loadbalancer.stickiness.httpOnly">true</Label>
          <Label Key="traefik.http.loadbalancer.stickiness.sameSite">none</Label>
          <Label Key="traefik.http.loadbalancer.stickiness.cookieName">stickycookie</Label>
        </Labels>
        </Extension>
      </Extensions>
    </StatelessServiceType>
  </ServiceTypes>
  ...
```

## Supported Labels (since 0.2.x) ##

*Entrypoints section*
* **traefik.http.entrypoints** Comma separated list of entrypoints to be assigned to router, e.g., Web, WebSecure.

*Rule section*
* **traefik.http.rule**    Traefik rule to apply [PathPrefix(`/dario`))]. This rule is added on top of the default path generation. If this is set, you **have** to define a middleware to remove the prefix for the service to receive the stripped path.

*Loadbalancer section*
* **traefik.http.loadbalancer.passhostheader**          passhostheaders ['true'/'false']
* **traefik.http.loadbalancer.healthcheck.path**        Healthcheck endpoint path ['/healtz']
* **traefik.http.loadbalancer.healthcheck.interval**    Healthcheck interval ['10s']
* **traefik.http.loadbalancer.healthcheck.scheme**      Healthcheck scheme ['http']
* **traefik.http.loadbalancer.stickiness**      Enable sticky sessions ['true'/'false']
* **traefik.http.loadbalancer.stickiness.secure**      Enable Secure flag for sticky session cookie ['true'/'false']
* **traefik.http.loadbalancer.stickiness.httpOnly**      Enable HTTPOnly flag for sticky session cookie ['true'/'false']
* **traefik.http.loadbalancer.stickiness.sameSite**      Enable SameSite flag for sticky session cookie ['none'/'lax'/'strict']
* **traefik.http.loadbalancer.stickiness.cookieName**      Enable static name for sticky session cookie ['stickycookie']

*Middleware section*
* **traefik.http.middleware.stripprefix**    prefix to strip ['/dario']


## License
This software is released under the MIT License