# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant::Config.run do |config|

  config.vm.box = 'centos6'

  # A hash table of boxes to define.
  # This is a lot cleaner imho than all those config.vm.define blocks.
  #
  # Each key will be used as the box name. The value should also be a hash.
  #
  # Example:
  #
  #   {
  #     :test => {
  #       :hostname     => 'test.virtual.vstone.eu',
  #       :ip           => '192.168.100.10',
  #       :forwards     => { 80 => 20080, 443 => 20443, },
  #       :box          => 'custom',
  #       :customize    => [ '--name', 'Test Box', '--memory', 1024, ],
  #       :environment  => 'develop',
  #     },
  #     :default => {
  #       :hostname => 'default.virtual.vstone.eu',
  #     }
  #   }.each do ...
  #
  {
    :test => {
      :hostname => 'test.virtual.vstone.eu',
      :ip       => '192.168.100.10',
      :forwards => { 80 => 20080, 443 => 20443, },
      :box      => 'custom',
    },
    :default => {
      :hostname => 'default.virtual.vstone.eu',
    },

    ## No vms after this point :)
  }.each do |name,cfg|
    config.vm.define name do |vm_config|
      vm_config.vm.host_name = cfg[:hostname] if cfg[:hostname]
      vm_config.vm.network :hostonly, cfg[:ip] if cfg[:ip]
      vm_config.vm.box = cfg[:box] if cfg[:box]

      if cfg[:forwards]
        cfg[:forwards].each do |from,to|
          vm_config.vm.forward_port from, to
        end
      end

      customize = ["modifyvm", :id] + (cfg[:modify] || [])
      if ! customize.include?("--name")
        # Add the name of the box to the vm-name in
        # VirtualBox so we can identify it easily in the GUI.
        customize += ["--name",
          File.basename(File.dirname(__FILE__)) +
          "-#{name}" + "_#{Time.now.to_i}" ]
      end
      vm_config.vm.customize customize

      vm_config.vm.provision :shell do |shell|
        shell.path = "scripts/run_puppet.sh"
        shell.args = cfg[:environment] if cfg[:environment]
      end
    end
  end

end
