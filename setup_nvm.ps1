# install npm after reboot
##########################
# install nvm + npm
##########################

echo "installing nvm"
choco install -y nvm --force
echo "update environment variables"
nvm install 8.11.1
refreshenv
echo "update nvm install/config"
refreshenv
nvm use 8.11.1
refreshenv
npm install -g bower
npm install -g grunt-cli
npm install -g karma
