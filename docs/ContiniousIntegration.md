# Continious Integration

## Pipeline

`qgroundcontrol_private` is connected to Jenkins to build binaries for all the plateform. This is usefull for release purpose as well as a development test. 
Running the pipeline on a develpment branch allow the developer to insure his work build in every plateform and not only on his machine for instance.

Here a simple diagram of the current pipeline : 
![image](https://user-images.githubusercontent.com/6662416/70398205-eb5a0180-1a7d-11ea-8b01-3197e5108f48.png)

## Jenkins

Jenkins is accessible through [this link](https://jenkins.aeronavics.com/jenkins2/blue/pipelines)

Several pipeline are set, the one related to qgroundcontrol has the name of the repository : qgroundcontrol_private

## Deployment

The pipeline is set to deploy on nexus either on stable or unstable.
Pipelines from prod branch will deploy a stable package on Nexus's artifact repository
Pipelines from master branch will deploy onto unstable. 

The "unstable" binaries are considered as beta versions and will be used for test purpose. In that way we keep track of each binary tested during the stabilization process.

The stable binaries are the release versions ready to be delivered to customers. In that way we keep archive of all version already delivered and have a way to store and access production packages. 

## Nexus

[Access Link](https://services.aeronavics.com/nexus/#browse/browse:qgroundcontrol:unstable)

Nexus is the artifact repository used to keep versioning of every binary produced by Aeronavics developers. 

It's also used as a docker registry to store containers used by the build

## Build

We need to build on several plateform, for that purpose Docker is used to build for Linux and Android and a virtual machine is used to build for Windows.

### Linux and Android

The GitHub repository "qgroundcontrol_containers" [here](https://github.com/Aeronavics/qgroundcontrol_containers) contains all the Dockerfile used to generate build containers.
Those containers have every dependencies installed to build qgroundcontrol for a specific target. The qgc_android container will contain the toolchain and all arm libraries to build an .apk package. The qgc_linux container will have everythink setup to generate an AppImage and a deb package of QGroundControl.

On push event on this repository a Jenkins pipeline will execute docker build on both Dockerfiles (qgc_android and qgc_linunx) to generate this images and push them to the Nexus docker registry. Then those images are accessible with a `docker push` command from our local Nexus registry. 

To access manually the images you will have to login to nexus though :

```
docker login pelardon.aeronavics.com:8083 --username your_user --password your_password
docker pull pelardon.aeronavics.com:8083/qgc_android:latest
```

This image can be run with a volume that contains a clone of qgroundcontrol_private repo : 

```
docker run --rm -it -v path_to_qgroundcontrol_private:/qgroundcontrol_private /bin/bash
```

That command will open a bash into the docker image, the normal process of `qmake .. && make` can be run to build.
