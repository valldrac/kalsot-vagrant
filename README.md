# Vagrantfile for OnionWall development

To generate a flashable firmare of [OnionWall](https://gitlab.com/valldrac/onionwall) you need to setup the [OpenWrt buildroot](https://openwrt.org/docs/guide-developer/build-system/install-buildsystem) on a compatible OS and filesystem (case sensitive).

This [Vagrant](https://www.vagrantup.com/) environment makes the process very easy on just about every platform.

## Bootstrapping the Vagrant Box

```
$ git clone --recursive https://gitlab.com/valldrac/onionwall-vagrant.git
$ cd onionwall-vagrant
$ vagrant up
```

The **buildroot** will be available in the VM path `/onionwall` when the provisioning script is complete.

## Building OnionWall

To proceed and build the firmware run this single command. It will SSH for you into the buildroot and will make all the magic:

```
$ make firmware
```

When finished, check out the image file with suffix `squashfs-sysupgrade.bin` in the host directory `firmware/bin/targets` and refer to https://gitlab.com/valldrac/onionwall/wikis/Flashing how-to.

If the build fails, re-run make with **V=s** for debugging output.

## Customizing OnionWall

The directory with the source code is configured as [rsynced shared folder](https://www.vagrantup.com/docs/synced-folders/rsync.html). It is synchronized automatically to the buildroot by the Makefile. This way lets you to **edit the sources directly in the host** while being completely isolated from the build process.

If you want to customize the image through [OpenWrt Configuration Interface](https://openwrt.org/docs/guide-developer/build-system/use-buildsystem#make_menuconfig) try:

```
$ make menuconfig
```

The above executes menuconfig in the buildroot and copies the config file back into the source tree. This file includes only the changes compared to the default configuration of OpenWrt.

## Cleaning up

```
$ make clean
```

Cleans the directory `firmware` and dot-files generated by Makefile, but it avoids touching the buildroot.

Additional targets to clean up the mess:

* `make dirclean` runs `make clean` both in the host and in the buildroot.
* `make distclean` runs `make clean` and deletes the buildroot completely in the VM.

Remember you can recreate the Vagrant box at any time with `vagrant destroy && vagrant up` followed by `touch onionwall`.
