#!/bin/sh -x
## get consistent ruby2+bundler env on each distribution

location=`dirname "$0"`
cd $location

## docker environment in travis missing few utils
[ -f /etc/debian_version ] && apt-get install -y curl
[ -f /etc/redhat-release ] && yum -y install which

curl -sSL https://get.rvm.io | bash
#[ -f $HOME/.rvm/scripts/rvm ] && . $HOME/.rvm/scripts/rvm
#[ -d /usr/local/rvm ] && . /etc/profile.d/rvm.sh

## troubleshoot
type rvm | head -1
env

#export PATH=/usr/local/rvm/bin:$PATH

bash -l -c "rvm install 2.0"
bash -l -c "rvm use 2.0"
bash -l -c "rvm use 2.0 --default"
bash -l -c "gem install bundler"
bash -l -c "bundle install --path ./gems"
if [ "X$USER" == "Xroot" -o "X$USER" == "X" ]; then
    bash -l -c "bundle exec rake spec"
else
    bash -l -c "env rvmsudo_secure_path=1 rvmsudo bundle exec rake spec"
fi

