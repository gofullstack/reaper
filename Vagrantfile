VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "chef/ubuntu-14.04"

  config.vm.network "forwarded_port", guest: 5000, host: 5000

  config.vm.synced_folder '.', '/home/vagrant/dev'

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe 'recipe[apt::default]'
    chef.add_recipe 'recipe[vim::default]'
    chef.add_recipe 'recipe[git::default]'
    chef.add_recipe 'recipe[nodejs::default]'
    chef.add_recipe 'recipe[brightbox-ruby::default]'
    chef.add_recipe 'recipe[postgresql::client]'
    chef.add_recipe 'recipe[postgresql::server]'
    chef.add_recipe 'recipe[sqlite::default]'
    chef.add_recipe 'recipe[reaper::default]'

    chef.json = {
      'brightbox-ruby' => {
        'version' => '1.9.1'
      },
      'postgresql' => {
        'pg_hba' => [
          { type: 'local', db: 'all', user: 'postgres', addr: nil, method: 'trust' },
          { type: 'host', db: 'all', user: 'vagrant', addr: '::1/128', method: 'trust' }
        ],
        'password' => {
          'postgres' => ''
        }
      }
    }
  end
end
