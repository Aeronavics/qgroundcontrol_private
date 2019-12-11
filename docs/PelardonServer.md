# Pelardon Server

Pelardon is the build server accessible at pelardon.aeronavics.com

It hosts several services for development and production purpose :

- Nexus : An artifact repositories system that help versioning and keeping track of each binaries produced durnig the build process.
    It's also used to store FlightController firmwares, Mission Computer Images and Flights logs automatically synchronized by Aeronavics GS (QGroundControl).
- Jenkins : A Continuious integration software. Connected to Github, it will trigger build processes and tests automatically. It's used to generate release binaries and will upload the release package on Nexus.
- LDAP : User database, is used to keep all users credentials for each pelardon services.
- phpLdapAdmin : A PHP based interface to easily configure LDAP

## Related Github repository

Pelardon infrastructure is fully integrated to Pagoda Ansible system. It means that the deployment is similar to any mission computer.
Ansible will insure the configuration of the server is always correct and will insure every dependencies are correctly installed.

## Architectural Diagram

The following figure describe the different interactions between services within and outside Pelardon server.

![Pelardon-Architecture](https://user-images.githubusercontent.com/6662416/70580449-b635e680-1c18-11ea-875d-c099d76285b9.png)

