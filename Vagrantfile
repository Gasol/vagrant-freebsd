# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box_version = '0.1.0'
  config.vm.guest = 'freebsd'
  config.vm.box = 'gasolwu/freebsd-10.0-amd64'
  config.vm.box_download_checksum_type = 'sha256'
  config.vm.box_download_checksum = '31406a4317c63264fe3cce8e0c5de6b3db80273a8d9f3f6110f2c4d31aba7af7'
  config.vm.network 'private_network', ip: '10.0.10.10'
  config.vm.synced_folder '.', '/vagrant', :nfs => true, id: 'vagrant-root'

  config.vm.provider 'virtualbox' do |vb|
    vb.customize ['modifyvm', :id, '--memory', '512']
    vb.customize ['modifyvm', :id, '--cpus', '2']
    vb.customize ['modifyvm', :id, '--hwvirtex', 'on']
    vb.customize ['modifyvm', :id, '--audio', 'none']
    vb.customize ['modifyvm', :id, '--nictype1', 'virtio']
    vb.customize ['modifyvm', :id, '--nictype2', 'virtio']
  end

end
