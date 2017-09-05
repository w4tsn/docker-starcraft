# TensorFlow StarCraft Docker-Image

This image is a starting point for running StarCraft Broodwar 1.16.1 in a docker container together with BWAPI, Python and TensorFlow.

**Why?**

This image enables a simple way to execute StarCraft bots on any docker compliant operating system.

It also provides TensorFlow and Python for Machine Learning integration into the bot-development.

Note: *Together with a [cross-compiled bot]() the development could be done completely on any operating system supporting docker.*

## Image Usage

This image is intended to be build by your own to include your legal copy of StarCraft Broodwar 1.16.1 right into the image.

Alternativly you can use this base image which is automatically build and mount a volume with StarCraft to `/home/starcraft/.wine/drive_c/StarCraft`.

### Image Build

```
docker build -t lionax/docker-starcraft .
```

### Image Export

```
# Get the ID of the docker container you want to export
docker ps -a
# Commit your changes to persist them
docker commit $ID
# Tag the Image with a Version
docker tag $ID docker-starcraft
# Save the image
docker save $ID -o docker-starcraft.docker
```

### Image Import

```
docker load -i docker-starcraft.docker
```

## Container Usage

**Summery:**

* The image provides a VNC-Server on port 5900
* The image provides a TensorFlow interface on port 8888
* The image contains BWAPI 4.1.2 and BWTA 2.2
* The volume `/home/starcraft/.wine/drive_c/bot` contains bot files (DLLs and Configs)
* The ENVIRONMENT variables `BOT_PATH` and `BOT_DEBUG_PATH` should point to the respective DLL file locations

**Run a basic instance:**

Per default an instance of StarCraft will be started on container start, if one is included in the image or mounted into the container under `/home/starcraft/.wine/drive_c/StarCraft`.

```
docker run --rm --privileged -it -p 8888:8888 -p 5900:5900 lionax/docker-starcraft /bin/bash
```

With this you find yourself in a shell session within the container to control the execution and injection of bots into StarCraft Broodwar.

**Important**: *The `--privileged` is mandatory. Without it the injector is not able to modify the memory for dll injections.*

**Inject a bot into StarCraft:**

The injection is done with [bwheadless](https://github.com/tscmoo/bwheadless).

Inject BWAPI into an instance of StarCraft through the following command:

```
su -c "wine explorer /desktop=DockerDesktop,1024x768 $STARCRAFT/bwheadless.exe -e $STARCRAFT/StarCraft.exe -l $STARCRAFT/bwapi-data/BWAPI.dll --headful" starcraft
```

Note: *Wine requires the command to be executed as starcraft user.*
