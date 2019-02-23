# README

This README would normally document whatever steps are necessary to get the
application up and running.

#HOW TO USE
<rails server

visit website< localhost:3000/accounts

<ruby nexus.rb
<RAILS_ENV=development ruby app/nexus.rb

#https://gorails.com/setup/windows/10


curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn

cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

rbenv install 2.4.1
rbenv global 2.4.1
ruby -v

sudo apt-get install libpq-dev

gem install rubygems -v 2.7.8
#apt-get install rubygems
gem install bundler -v 1.16.6

#curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
#sudo apt-get install -y nodejs

gem install rails -v 5.2.1
gem install bundler -v 1.16.6
gem install pg -v '1.1.4' --source 'https://rubygems.org/'

rbenv rehash

#sudo apt install -y ruby-bundler

cd /mnt/c/oxnet
bundle install

#sudo apt-add-repository ppa:brightbox/ruby-ng
#sudo apt-get update
#sudo apt-get install ruby2.4 ruby2.4-dev