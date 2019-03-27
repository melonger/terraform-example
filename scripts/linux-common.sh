#!/bin/bash -x

#########################################################################
## Starting Common Script
#########################################################################

touch /tmp/testing.log

missingmount="true"
drives="${device_name}"
drivenames="${mount_name}"
count=0
IFS=',' read -r -a array <<< "$drivenames"
echo $a
for i in $(echo $drives | sed "s/,/ /g"); do
    missingmount="true"
    echo y | mkfs.ext4 /dev/$i
    chattr -i /etc/fstab
    echo "/dev/$i /home/$drivenames ext4 defaults 1 1" >> /etc/fstab
    chattr +i /etc/fstab
    mkdir -p /home/$drivenames
    mount /home/$drivenames
    while [ "$missingdrive" != "false" ]
    do
        info=$(echo "$a" | lsblk |grep $drivenames)
        echo "missing $drivenames drive"
        sleep 2
        if [[ $info == *"$drivenames"* ]]
        then
            missingdrive="false";
            echo "drive avaiable"
        fi
    done
    count=$count+1
done
setsebool httpd_can_network_connect 1

JAIL="/home/jail"
function create_Service {
cat <<- _EOF_
useradd -m -d /home/\$1 -k /etc/skel -s /bin/bash -U \$1 && \\
OUTPUT="\$(date +%s | sha256sum | base64 | head -c 10)" && \\
echo \$1:\$OUTPUT | chpasswd && \\
echo "Username \$1 Password \$OUTPUT" >> /home/jail/passwords
_EOF_
}
export -f create_Service
# create_Service > /home/jail/createService

yum install -y git unzip epel-release && yum install -y wget nano net-tools htop sshpass multitail jnettop mlocate tcpdump screen tmux
yum --enablerepo=epel-testing -y install jnettop

mkdir -p $JAIL && chmod 0700 $JAIL

if [ -f "$JAIL/createService" ]
then
	echo "createService already exists, skipping..."
else
  create_Service > $JAIL/createService
  chmod +x $JAIL/createService && ln -s $JAIL/createService /sbin/createService
  echo "createService file created in $JAIL and linked inside of /sbin"
fi

mv /etc/localtime $JAIL/
ln -s /usr/share/zoneinfo/America/Montreal /etc/localtime

# sed -i 's/#force_color/force_color/g' /etc/skel/.bashrc &&
dircolors -p > /etc/skel/.dircolors && sed -i 's/DIR\ 01;34/DIR\ 01;36/g' /etc/skel/.dircolors

su azureuser -c 'cp /etc/skel/.* ~' || :

###############################
## Chef Prep and Setup
###############################

CHEFDIR="/home/chef"
CHEFVER="14.0.202"
[[ -z "$1" ]] && PROJECT="project-base" || PROJECT="$1"

function create_config {
cat <<- _EOF_
chef_dir                "/home/chef/.chef"
log_level               :info
log_location            "/tmp/chefdebug.log"
cookbook_path           "#{chef_dir}/cookbooks"
file_cache_path         "#{chef_dir}/cache"
environment_path        "#{chef_dir}/environments"
role_path               "#{chef_dir}/roles"
local_mode              :true
solo                    :true
_EOF_
}

# Key missing half to keep anon
function create_ssh_key {
cat <<- _EOF_
${ssh_private_key}
_EOF_
}

# Key missing half to keep anon
function create_ssh_pub {
cat <<- _EOF_
${ssh_public_key}
_EOF_
}

##############################
# Init
##############################
export -f create_config
export -f create_ssh_key
export -f create_ssh_pub

###############################
## Chef Setup
###############################
chef-client -version | awk '{print $2}'
retval="$?"
if [ $retval -ne 0 ]; then
  echo "Chef is already installed"
else
  rpm -ivh https://packages.chef.io/files/stable/chef/$CHEFVER/el/7/chef-$CHEFVER-1.el7.x86_64.rpm
fi

chkconfig --del chef-client

mkdir -p /etc/chef && create_config > /etc/chef/solo.rb && create_config > /etc/chef/client.rb

if [ ! -d "$CHEFDIR/.chef" ]; then
  echo "Creating Chef User"
  createService chef || :
  if [ ! -d "$CHEFDIR/.ssh" ]; then
    echo "Creating .ssh directory for Chef User"
    su chef -c 'mkdir -p ~/.ssh && chmod 0700 ~/.ssh && create_ssh_key > ~/.ssh/id_rsa && create_ssh_pub > ~/.ssh/id_rsa.pub && chmod 600 ~/.ssh/id_rsa && echo -e "Host *\n\tStrictHostKeyChecking no" > ~/.ssh/config'
  else
    echo ".ssh directory already exists for Chef User"
  fi
  echo "pulling chef directory from git"
  su -c "cd ~ && git clone git@github.com:melonger/$PROJECT.git ~/.chef" chef
else
  echo ".chef directory already exists for Chef User"
fi

if [ ! -d "$CHEFDIR/.chef/cookbooks" ]; then
  echo "pulling devops cookbook from git"
  su -c 'cd /home/chef/.chef; git clone git@github.com:melonger/cookbooks.git' chef
else
  echo "devops cookbook already exists for Chef User"
fi

if [ ! -d "$CHEFDIR/.chef/cookbooks/devops" ]; then
  echo "pulling devops cookbook from git"
  su -c 'cd /home/chef/.chef/cookbooks/; git clone git@github.com:melonger/devops.git' chef
else
  echo "devops cookbook already exists for Chef User"
fi

# chown -R chef:chef /home/chef/.chef
su chef -c 'cp /etc/skel/.* ~' || :

#########################################################################
## Finished Common Script
#########################################################################
