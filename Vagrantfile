# -*- mode: ruby -*-
# vi: set ft=ruby :
# Verify whether required plugins are installed.

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'

# Verify whether required plugins are installed.
# =>  vagrant-mutate : a vagrant plugin to convert vagrant boxes to work with
#                      different providers.
# =>  vagrant-libvirt : is a plugin that adds a Libvirt provider to Vagrant,
#                       allowing Vagrant to control and provision machines via
#                       Libvirt toolkit.
required_plugins = [ "vagrant-mutate", "vagrant-libvirt" ]
required_plugins.each do |plugin|
  if not Vagrant.has_plugin?(plugin)
    raise "The vagrant plugin #{plugin} is required. Please run `vagrant plugin install #{plugin}`"
  end
end

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|      
  #----------------------------------------------------------------------------
  # Available Settings
  #----------------------------------------------------------------------------
  #
  # If true, Vagrant will check for updates to the configured box on every
  # vagrant up. If an update is found, Vagrant will tell the user. By default 
  # this is true. Updates will only be checked for boxes that properly support
  # updates.
  config.vm.box_check_update = false
  
  # Configures synced folders on the machine, so that folders on your host 
  # machine can be synced to and from the guest machine. Please see the page on
  # synced folders for more information on how this setting works.
  config.vm.synced_folder ".", "/vagrant", type: "rsync"

  #----------------------------------------------------------------------------
  # Configures provider-specific configuration, which is used to modify settings
  # which are specific to a certain provider.
  #----------------------------------------------------------------------------
  config.vm.provider :libvirt do |libvirt|
    # If use ssh tunnel to connect to Libvirt. Absolutely needed to access
    # Libvirt on remote host. It will not be able to get the IP address of a
    # started VM otherwise.
    libvirt.connect_via_ssh = false
    
    # A hypervisor name to access. For now only KVM and QEMU are supported.
    libvirt.driver = "kvm"
    
    # The name of the server, where Libvirtd is running
    libvirt.host = "localhost"

    # For advanced usage. Directly specifies what Libvirt connection URI
    # vagrant-libvirt should use. Overrides all other connection configuration
    # options
    libvirt.uri = "qemu:///system"
    
    # Pass through /dev/random to the VM
    libvirt.random :model => "random"

    # Libvirt storage pool name, where box image and instance snapshots will be
    # stored.
    libvirt.storage_pool_name = "libvirt"
  end

  #----------------------------------------------------------------------------
  # Configures provisioners on the machine, so that software can be 
  # automatically installed and configured when the machine is created.
  #----------------------------------------------------------------------------
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "tests/vagrant/playbook.yml"
    ansible.inventory_path = "tests/vagrant/inventory"
  end

  #----------------------------------------------------------------------------
  # OS distro CentOS v8
  #----------------------------------------------------------------------------
  config.vm.define :dacent8 do |node|
    node.vm.box = "centos/8"
    node.vm.hostname = "dacent8"
    
    # Configures additional networks on the machine.
    node.vm.network :private_network,
      :type => "dhcp",
      :libvirt__dhcp_enabled  => false,
      :libvirt__domain_name => "example.local",
      :libvirt__guest_ipv6 => "yes",
      :libvirt__forward_mode => "none"

    node.vm.provider :libvirt do |v|
      # Automatically start the domain when the host boots. Defaults to 'false'.
      v.autostart = false

      # Number of virtual cpus. Defaults to 1 if not set.
      v.cpus = 1

      # The type of disk device to emulate. Defaults to virtio if not set.
      v.disk_bus = "virtio"
      
      # The disk device to emulate. Defaults to vda if not set, which should be
      # fine for paravirtualized guests, but some fully virtualized guests may
      # require hda. 
      v.disk_device = "vda"

      # Amount of memory in MBytes. Defaults to 512 if not set.
      v.memory = 1024

      # Set keymap for vm. 
      v.keymap = "fr-be"

      # Sets machine architecture. This helps Libvirt to determine the correct
      # emulator type.
      v.machine_arch = 'x86_64'

      # Sets the disk size in GB for the machine overriding the default 
      # specified in the box. Allows boxes to defined with a minimal size disk
      # by default and to be grown to a larger size at creation time.
      v.machine_virtual_size = 12
      
      # Decide if VM has interface in mgmt network. Defaults set to 'true'.
      v.mgmt_attach =  true

      # Name of Libvirt network to which all VMs will be connected. 
      # If not specified the default is 'vagrant-libvirt'.
      v.management_network_name = "vagrant-libvirt"

      # MAC address of management network interface.
      v.management_network_mac = "52:54:00:85:39:59"

      # Enable or disable guest-to-guest IPv6 communication. 
      v.management_network_guest_ipv6 = false

      # Sets the protocol used to expose the guest display. Defaults to 'vnc'.
      v.graphics_type = "spice"
      
      # Sets the IP for the display protocol to bind to. 
      # Defaults to "127.0.0.1".
      v.graphics_ip = "127.0.0.1"
      
      # Sets autoport for graphics, Libvirt in this case ignores graphics_port
      # value, Defaults to 'yes'. 
      v.graphics_autoport = "yes"
      
      # Sets the graphics card type exposed to the guest. Defaults to 'cirrus'.
      v.video_type = "qxl"
      
      # Used by some graphics card types to vary the amount of RAM dedicated
      # to video. Defaults to '9216'.
      v.video_vram = 1024
    end  
  end

  #----------------------------------------------------------------------------
  # OS distro CentOS v7
  #----------------------------------------------------------------------------
  config.vm.define :dacent7 do |node|
    node.vm.box = "centos/7"
    node.vm.hostname = "dacent7"

    # Configures additional networks on the machine.
    node.vm.network :private_network,
      :type => "dhcp",
      :libvirt__dhcp_enabled  => false,
      :libvirt__domain_name => "example.local",
      :libvirt__guest_ipv6 => "yes",
      :libvirt__forward_mode => "none"

    node.vm.provider :libvirt do |v|
      v.autostart = false
      v.cpus = 1
      v.disk_bus = "virtio"
      v.disk_device = "vda"
      v.memory = 1024
      v.keymap = "fr-be"
      v.machine_arch = 'x86_64'
      v.management_network_mac = "52:54:00:6b:5d:a0"
      v.management_network_guest_ipv6 = false
      v.graphics_type = "spice"   
      v.graphics_ip = "127.0.0.1"
      v.video_type = "qxl"
      v.video_vram = 1024
    end  
  end

  #----------------------------------------------------------------------------
  # OS distro Fedora v32
  #----------------------------------------------------------------------------
  config.vm.define :dafedo32 do |node|
    node.vm.box = "generic/fedora32"
    node.vm.hostname = "dafedo32"

    # Configures additional networks on the machine.
    node.vm.network :private_network,
      :type => "dhcp",
      :libvirt__dhcp_enabled  => false,
      :libvirt__domain_name => "example.local",
      :libvirt__guest_ipv6 => "yes",
      :libvirt__forward_mode => "none"

    node.vm.provider :libvirt do |v|
      v.autostart = false
      v.cpus = 1
      v.disk_bus = "virtio"
      v.disk_device = "vda"
      v.memory = 1024
      v.keymap = "fr-be"
      v.machine_arch = 'x86_64'
      v.management_network_mac = "52:54:00:4a:b5:55"
      v.management_network_guest_ipv6 = false
      v.graphics_type = "spice"   
      v.graphics_ip = "127.0.0.1"
      v.video_type = "qxl"
      v.video_vram = 1024
    end  
  end

  #----------------------------------------------------------------------------
  # OS distro Manjaro Linux
  #----------------------------------------------------------------------------
  config.vm.define :damanj do |node|
    node.vm.box = "finiks/manjaro-20.0.3"
    node.vm.hostname = "damanj"

    # Configures additional networks on the machine.
    node.vm.network :private_network,
      :type => "dhcp",
      :libvirt__dhcp_enabled  => false,
      :libvirt__domain_name => "example.local",
      :libvirt__guest_ipv6 => "yes",
      :libvirt__forward_mode => "none"

    node.vm.provider :libvirt do |v|
      v.autostart = false
      v.cpus = 1
      v.disk_bus = "virtio"
      v.disk_device = "vda"
      v.memory = 1024
      v.keymap = "fr-be"
      v.machine_arch = 'x86_64'
      v.management_network_mac = "52:54:00:4a:b5:01"
      v.management_network_guest_ipv6 = false
      v.graphics_type = "spice"   
      v.graphics_ip = "127.0.0.1"
      v.video_type = "qxl"
      v.video_vram = 1024
    end  
    
  end
end
