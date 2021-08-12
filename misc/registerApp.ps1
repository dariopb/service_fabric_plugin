
Connect-ServiceFabricCluster

# Register and run the Traefik Application
Remove-ServiceFabricApplication -ApplicationName fabric:/traefik -Force
Unregister-ServiceFabricApplicationType -ApplicationTypeName TraefikType -ApplicationTypeVersion 1.0.0 -Force

Copy-ServiceFabricApplicationPackage -ApplicationPackagePath .\traefik\ -ApplicationPackagePathInImageStore traefik
Register-ServiceFabricApplicationType -ApplicationPathInImageStore traefik
New-ServiceFabricApplication -ApplicationName fabric:/traefik -ApplicationTypeName TraefikType -ApplicationTypeVersion 1.0.0


# Sample pinger app for validating (navidate to /pinger/PingerService/id)
Remove-ServiceFabricApplication -ApplicationName fabric:/pinger -Force
Unregister-ServiceFabricApplicationType -ApplicationTypeName PingerApplicationType -ApplicationTypeVersion 1.0 -Force

Copy-ServiceFabricApplicationPackage -ApplicationPackagePath .\pinger.windows-traefik\ -ApplicationPackagePathInImageStore pinger
Register-ServiceFabricApplicationType -ApplicationPathInImageStore pinger
New-ServiceFabricApplication -ApplicationName fabric:/pinger -ApplicationTypeName PingerApplicationType -ApplicationTypeVersion 1.0

