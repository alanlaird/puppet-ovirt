require 'spec_helper'

describe 'ovirt::repo' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('ovirt::repo') }
  it { should contain_class('ovirt') }
  it { should contain_class('epel') }

  it { should contain_stage('ovirt_repo_clean').that_comes_before('Stage[main]') }
  it { should contain_class('ovirt::repo::clean').with_stage('ovirt_repo_clean') }

  it do
    should contain_file('/etc/pki/rpm-gpg/RPM-GPG-ovirt').with({
      :ensure => 'present',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0644',
      :source => 'puppet:///modules/ovirt/RPM-GPG-ovirt',
    })
  end

  it do
    should contain_gpg_key('RPM-GPG-ovirt').with({
      :path   => '/etc/pki/rpm-gpg/RPM-GPG-ovirt',
      :before => 'Yumrepo[ovirt-stable]',
    })
  end

  if Gem::Version.new(PUPPET_VERSION) >= Gem::Version.new('3.5.0')
    it { should contain_yumrepo('ovirt-3.4-epel').with_ensure('absent') }
    it { should contain_yumrepo('ovirt-stable').with_ensure('present') }
    it { should contain_yumrepo('ovirt-glusterfs-epel').with_ensure('present') }
    it { should contain_yumrepo('ovirt-glusterfs-noarch-epel').with_ensure('present') }
    it { should contain_yumrepo('ovirt-jpackage-6.0-generic').with_ensure('present') }
  else
    it { should_not contain_yumrepo('ovirt-3.4-epel') }
    it { should contain_yumrepo('ovirt-stable').without_ensure }
    it { should contain_yumrepo('ovirt-glusterfs-epel').without_ensure }
    it { should contain_yumrepo('ovirt-glusterfs-noarch-epel').without_ensure }
    it { should contain_yumrepo('ovirt-jpackage-6.0-generic').without_ensure }
  end

  if Gem::Version.new(PUPPET_VERSION) >= Gem::Version.new('3.6.0')
    it { should contain_yumrepo('ovirt-stable').with_skip_if_unavailable('1') }
    it { should contain_yumrepo('ovirt-glusterfs-epel').with_skip_if_unavailable('1') }
    it { should contain_yumrepo('ovirt-glusterfs-noarch-epel').with_skip_if_unavailable('1') }
    it { should contain_yumrepo('ovirt-jpackage-6.0-generic').without_with_skip_if_unavailable }
  else
    it { should contain_yumrepo('ovirt-stable').without_with_skip_if_unavailable }
    it { should contain_yumrepo('ovirt-glusterfs-epel').without_with_skip_if_unavailable }
    it { should contain_yumrepo('ovirt-glusterfs-noarch-epel').without_with_skip_if_unavailable }
    it { should contain_yumrepo('ovirt-jpackage-6.0-generic').without_with_skip_if_unavailable }
  end

end
