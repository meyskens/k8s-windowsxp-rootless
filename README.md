# Rootless Windows XP in Docker/Kubernetes

This repository contains files needed to run Windows XP in Docker without having to run as `--privileged`.
Personally I use this in Kubernetes to send commands to my UPS which came with very old software on a CD.

## Running this

This repo does not come with a Windows XP ISO.
First we have to install Windows XP on a disk using an ISO. Place the ISO as `winxp.iso` in your current directory and run:
```
docker run --net=host -v $(pwd):/media maartje/k8s-windows-xp-rootless -d /media/winxp.img -c /media/winxp.iso
```
`--net-host` is added here for easy acces to the QEMU VNC server which is bound to localhost. 
Now follow the Windows XP installation and enable Remote Desktop, then shut down the machine.

When you want to use Windows XP now you can run:
```
docker run -p 3389:3389 $(pwd):/media maartje/k8s-windows-xp-rootless -d /media/winxp.img
```
`winxp.img` is your HDD file, if you want to use this in Kubernetes you can upload this file to your PVC.
RDP is port-forwarded to 3389.

## Running in Kubernetes
You can run the installation in Kubernetes but it is not reccomended IMO.
There are manifest files to install this in `manifests/`. If you are not familiar with the resources in these files this repository is probably not for you.
First don't forget to change the `storageClassName`.
By default the deployment is set to wait till a HDD file is uploaded using:
```
kubectl cp <HDD file> <pod name>:/media/winxp.img
```

## Should I use this in production?
**NO**