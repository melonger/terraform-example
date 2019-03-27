#!/bin/env bash
#########################################################################
## Starting Boot Script
#########################################################################

## Variables
JAIL="/home/jail"
# CHEFDIR="/home/chef"
# CHEFVER="14.0.202"
# [[ -z "$1" ]] && PROJECT="project-base" || PROJECT="$1"

yum install -y git unzip epel-release && yum install -y wget nano net-tools htop sshpass multitail jnettop mlocate tcpdump screen tmux
yum --enablerepo=epel-testing -y install jnettop

mkdir -p $JAIL && chmod 0700 $JAIL

if [ -f "$JAIL/createService" ]
then
	echo "createService already exists, skipping..."
else
  echo 'useradd -m -d /home/$1 -k /etc/skel -s /bin/bash -U $1 && \' > $JAIL/createService
  echo 'OUTPUT="$(date +%s | sha256sum | base64 | head -c 10)" && \' >> $JAIL/createService
  echo 'echo -e "${OUTPUT}\n${OUTPUT}" | passwd $1 && \' >> $JAIL/home/vault/createService
  echo "echo \"Username \$1 Password \${OUTPUT}\" >> $JAIL/passwords" >> $JAIL/createService
  chmod +x $JAIL/createService && ln -s $JAIL/createService /sbin/createService
  echo "createService file created in $JAIL and linked inside of /sbin"
fi

mv /etc/localtime $JAIL/
ln -s /usr/share/zoneinfo/America/Montreal /etc/localtime

# sed -i 's/#force_color/force_color/g' /etc/skel/.bashrc &&
dircolors -p > /etc/skel/.dircolors && sed -i 's/DIR\ 01;34/DIR\ 01;36/g' /etc/skel/.dircolors

# function create_config {
# cat <<- _EOF_
# chef_dir                "/home/chef/.chef"
# log_level               :info
# log_location            "/tmp/chefdebug.log"
# cookbook_path           "#{chef_dir}/cookbooks"
# file_cache_path         "#{chef_dir}/cache"
# environment_path        "#{chef_dir}/environments"
# role_path               "#{chef_dir}/roles"
# local_mode              :true
# solo                    :true
# _EOF_
# }
#
# # Key missing half to keep anon
# function create_ssh_key {
# cat <<- _EOF_
# -----BEGIN RSA PRIVATE KEY-----
# MIIEpAIBAAKCAQEAo4wBFWFS6qftoAAk15vx27uzKCRBTold8DGwa29eeLfgTWv8
# 8K8yh3jkN9dk1bRRhG211qILOd3jBeGzWjH44pjC0amVxB4DHSxI7TdkgHazMRNf
# ZpDUKFa9oDoE0rmwZOQIxmGj4EZBf7QHqTUl1k5F2Ku8q41EZyisSPxrK+3CUhT5
# ktzNwPMFUIpzcMC0Ht2uGUAzObkYptexRL0SFFHU81L7ATvXYNmiShv1vi2e86Qw
# beRwLU1b20v3iVqprgD/3XTQb5XxPDYJ4WTU87GrqrA9JYSSJYdUQMs0Eanm36a9
# a8Ut6E2zqLyAForH/M0VG+DxEByfLA82QwUMcQIDAQABAoIBAAvag+GW0jmrvi9Q
# k1sFNHxmmE+agRk+H47fKxg+VCyPtzQlVYnkSNdEzdW2SNqsXRQqF3nc+M9S47dz
# alppMM7Ln6MulWpHepZMtWRsFV6yO76c1tdKO/ZIgynvypWzW7OUS4aFYSlKLkkh
# MOZ9HtlArpcuSoxY/Zji8pyk/lffXN83ZnFOzrzT69GlDKGedqPQTA==
# -----END RSA PRIVATE KEY-----
# _EOF_
# }
#
# # Key missing half to keep anon
# function create_ssh_pub {
# cat <<- _EOF_
# ssh-rsa AAAAB3NzaC1yc2EAAAADAQJWqmuAP/ddNBvlfE8NgnhZNTzsauqsD0lhJIlh1RAyzQRqebfpr1rxS3oTbOovIAWisf8zRUb4PEQHJ8sDzZDBQxx DevOpsKey
# _EOF_
# }

###############################
## Init
###############################
# export -f create_config
# export -f create_ssh_key
# export -f create_ssh_pub

# ###############################
# ## Chef Setup
# ###############################
# chef-client -version | awk '{print $2}'
# retval="$?"
# if [ $retval -ne 0 ]; then
#   echo "Chef is already installed"
# else
#   rpm -ivh https://packages.chef.io/files/stable/chef/$CHEFVER/el/7/chef-$CHEFVER-1.el7.x86_64.rpm
# fi
#
# chkconfig --del chef-client
#
# mkdir -p /etc/chef && create_config > /etc/chef/solo.rb && create_config > /etc/chef/client.rb
#
# if [ ! -d "$CHEFDIR/.chef" ]; then
#   echo "Creating Chef User"
#   createService chef || :
#   if [ ! -d "$CHEFDIR/.ssh" ]; then
#     echo "Creating .ssh directory for Chef User"
#     su chef -c 'mkdir -p ~/.ssh && chmod 0700 ~/.ssh && create_ssh_key > ~/.ssh/id_rsa && create_ssh_pub > ~/.ssh/id_rsa.pub && chmod 600 ~/.ssh/id_rsa && echo -e "Host *\n\tStrictHostKeyChecking no" > ~/.ssh/config'
#   else
#     echo ".ssh directory already exists for Chef User"
#   fi
#   echo "pulling chef directory from git"
#   su chef -c "cd ~ && git clone ssh://git@bitbucket.com:7999/chefp/$PROJECT.git ~/.chef"
# else
#   echo ".chef directory already exists for Chef User"
# fi
#
# if [ ! -d "$CHEFDIR/.chef/cookbooks" ]; then
#   echo "pulling devops cookbook from git"
#   su chef -c 'cd /home/chef/.chef; git clone ssh://git@bitbucket.com:7999/cbk/cookbooks.git'
# else
#   echo "devops cookbook already exists for Chef User"
# fi
#
# if [ ! -d "$CHEFDIR/.chef/cookbooks/devops" ]; then
#   echo "pulling devops cookbook from git"
#   su chef -c 'cd /home/chef/.chef/cookbooks/; git clone ssh://git@bitbucket.com:7999/cbk/devops.git'
# else
#   echo "devops cookbook already exists for Chef User"
# fi

# chown -R chef:chef /home/chef/.chef
# su chef -c 'cp /etc/skel/.* ~' || :
# su azureuser -c 'cp /etc/skel/.* ~' || :

#########################################################################
## Finished Boot Script
#########################################################################

# EOF
