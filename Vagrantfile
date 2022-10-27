# -*- mode: ruby -*-
# vi: set ft=ruby :
BOX_IMAGE = "ubuntu/focal64"
DOMAIN = "aula104.local"
DNSIP = "192.168.33.11"
LAB = "bind9"
BOX_DESKTOP = "gusztavvargadr/ubuntu-desktop"


maquinas = {
  "dns"    => {
    "network" => '192.168.33.11',
    "provision" => {
      "dns-server" => {"path" => "enable-bind-9.sh", 'args' => DNSIP},
    }},
  "apache1" => {
    "network" => '192.168.33.12',
    "provision" => {
      "apache-server" => {"path" => "apache.sh"},
      "dns-client" => {"path" => "dnsclient.sh", 'args' => DNSIP},
    }},
  "apache2" => {
    "network" => '192.168.33.13',
    "provision" => {
      "apache-server" => {"path" => "apache.sh"},
      "dns-client" => {"path" => "dnsclient.sh", 'args' => DNSIP},
    }},
    
  "nginx"  => {
    "network" => '192.168.33.14',
    "provision" => {
      "dns-client" => {"path" => "dnsclient.sh", 'args' => DNSIP},
      "nginx"      => {"path" => "nginx.sh"},
    }},
    "desktop" => {
      "network" => '192.168.33.15',
      "provision" => {
        "dns-client" => {"path" => "dnsclient.sh", 'args' => DNSIP}
      }
    }
}

Vagrant.configure("2") do |config|

  config.vm.box = BOX_IMAGE
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 1
    vb.memory = 1024
    vb.customize ["modifyvm", :id, "--groups", "/DNSLAB9"]
  end

  maquinas.each do |key,value|
    config.vm.define "#{key}" do |maquina|
      maquina.vm.provider "virtualbox" do |vb, subconfig| 
        vb.name = "#{key}"
        subconfig.vm.hostname = "#{key}.#{DOMAIN}"
        subconfig.vm.network :private_network, ip: "#{value['network']}",  virtualboxintnet: LAB # ,  name: RED #
        if "#{key}" == "desktop" then
          subconfig.vm.box = BOX_DESKTOP
          vb.gui = true
          vb.cpus = 2
          vb.memory = 2048
        end
      end
      value['provision'].each do |nombre, comand|
        maquina.vm.provision "shell", name: "#{nombre}", path: "#{comand['path']}", args: "#{comand['args']}"
      end
    end
  end
end
