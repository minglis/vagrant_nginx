# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

 config.vm.provision :puppet, :module_path => "modules", :options => ["--fileserverconfig=/vagrant/fileserver.conf", ]
 config.vm.share_folder "files", "/etc/puppet/files", "files"

 config.vm.forward_port 80, 4567
 config.vm.forward_port 443, 4568
end
