# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.define "influxdb" do |acs|
    acs.vm.box = "ubuntu/trusty64"
    acs.vm.hostname = "influxdb"
    acs.vm.network "private_network", ip: "192.168.33.10"
  end

  config.vm.define "monitored" do |monitoring|
    monitoring.vm.box = "ubuntu/trusty64"
    monitoring.vm.hostname = "monitored"
    monitoring.vm.network "private_network", ip: "192.168.33.40"
  end

  config.vm.define "webserver" do |web|
    web.vm.box="ubuntu/trusty64"
    web.vm.hostname = "webserver"
    web.vm.network "private_network", ip: "192.168.33.20"
#   web.vm.network "forwarded_port", guest: 80, host: 8080
  end

  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/trusty64"
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.33.30"
  end
  
 
end
