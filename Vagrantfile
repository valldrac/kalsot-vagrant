# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04"
  
  # Disable automatic box update checking
  config.vm.box_check_update = false

  # Prevent Vagrant from mounting the default /vagrant synced folder
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Sync firmware images and binary packages
  config.vm.synced_folder "firmware", "/firmware"

  # Run the building process in a private copy of the buildroot
  config.vm.synced_folder "onionwall", "/onionwall", type: "rsync",
    rsync__args: ["--archive", "--delete", "-F"]

  config.vm.provision "shell", privileged: false, path: "scripts/bootstrap"
end
