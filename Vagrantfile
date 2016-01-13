$packages  = <<SCRIPT
  apt-get update
  apt-get install -y redis-server \
                     nodejs \
                     git-core \
                     curl \
                     zlib1g-dev \
                     build-essential \
                     libssl-dev \
                     libreadline-dev \
                     libyaml-dev \
                     libsqlite3-dev \
                     sqlite3 \
                     libxml2-dev \
                     libxslt1-dev \
                     libcurl4-openssl-dev \
                     python-software-properties \
                     libffi-dev
SCRIPT

$bootstrap = <<SCRIPT
  cd $HOME
  git clone git://github.com/sstephenson/rbenv.git .rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bash_profile
  echo 'eval "$(rbenv init -)"' >> $HOME/.bash_profile

  git clone git://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> $HOME/.bash_profile
  source $HOME/.bash_profile

  rbenv install -v 2.2.2
  rbenv global 2.2.2
  echo 'gem: --no-document' > $HOME/.gemrc
  gem install bundler
  rbenv rehash
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box            = "ubuntu/trusty64"
  config.vm.hostname       = "oceano"
  config.ssh.insert_key    = false
  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
  end

  config.vm.network "private_network", ip: "10.10.10.20"
  config.vm.network "forwarded_port", guest: 3000,  host: 3000

  config.vm.provision "shell", inline: $packages
  config.vm.provision "shell", inline: $bootstrap, privileged: false
end
