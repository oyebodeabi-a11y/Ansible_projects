SETTING UP CONNECTION BETWEEN THE CONTROLLER AND THE TARGETS MACHINES

Ansible should be able to communicate to the other servers through passwordless authentication.. That's the only condition
If ansible can do that it can do anything

# always talk to the private ip address of the target machines

Copy it and do ssh to that machine see what happens

ssh  <private-ip>

It will ask for password: bc i have not configured any passwordless authentication on that machine

Error 

Permission denied (publickey).


# some other documentation might say just do
 
ssh-copy-id <private-ip>

#While this might have work but at times bc of lack enough permission u are denied
So the best ways of doing this

#On the controller ubuntu server just type 

ssh-keygen 


Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/ubuntu/.ssh/id_ed25519): 

# if you do 
cd .ssh/
ls

authorized_keys  id_ed25519  id_ed25519.pub 

# carry out
cat id_ed25519.pub

# You can share the id_ed25519.pub.pub but never share the id_ed25519 or id_rsa

# Always go with the public key to communicate with other servers

#You dont want to communicate using the password but u can use the public key to talk to the target servers using the ansible passwordless methods

Cat /home/ubuntu/.ssh/id_ed25519.pub


cat ~/.ssh/id_ed25519.pub

ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKeIzvy7K1dNWsbFzAHDBjmlpQOOQ0QIGLf1bicKH4v ubuntu@ip-172-31-4-109

Copy the above and take to the target server through ssh connection and 


# once on the target machine do 

ssh-keygen 

#And do 
ls ~/.ssh/
authorized_keys  id_ed25519  id_ed25519.pub

#now do this
Cd .ssh/

vi authorized_keys

ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKeIzvy7K1dNWsbFzAHDBjmlpQOOQ0QIGLf1bicKH4v ubuntu@ip-172-31-4-109



# Save the file


# Now go back to the ansible controller and do ssh again to the target machine

# The above will generate public and private key for you, it implies that i can comfortably ssh into these machines

Second phase
I need to confirm that the user aM WORKING WITH HAS SUDO ACCESS

Make sure the user has a sudo access, meaning it has a root privileged, the ubuntu has a sudo access by default, she cann not provide password does not allow the user to provide password

sudo su -
Cd /etc/sudoers.d
Ls
90-cloud-init-users

# go into the file
Vim 90-cloud-init-users

# User rules for ubuntu
ubuntu ALL=(ALL) NOPASSWD:ALL
~                                   
#meaning the machine should not be asked to perform root based authorization anytime
—---

If the above its ok check ifconfig on all the target machines and the ansible controller machine

sudo apt install net-tools
==============

# now lets go back to the ansible controller

cd .ssh/
ssh <ipadress-of-targetsmachies>
Exit and go back to the controller
Do the same thing for the green machines
===============
# We have confirm we can ssh into all target machines but lets do it with ansible for now if we can ping these machines

ansible all -i inventory -m ping

# the comma tells ansible that this is an inventory files and the ping shows the type of module am using

So far we have shown that we can ssh to this machine through this  and show that we can initiate connect through the controller machines and target machines but these is not allowed in corporate settings we should be able to put them in a inventory files or groups, so we need to use inventory file

# create inventory file as shown below
touch inventory

vi inventory

172.31.0.148
172.31.8.33


======================================
In shell u cal iot shell script
In python u call python files
In ansible u call ansible playbooks

# Is it compulsory to always write ansible playbooks No, u may want to do simple task then #use adhoc commands such as below 

ansible -i inventory all -a "ls -lart"

# to create a file text.txt on all machines
ansible -i inventory all -a "touch text.txt"

# now make directory cloud on all machines

ansible -i inventory all -a "mkdir cloud
#find the list of items in the target machines

ansible -i inventory all -a "ls"

# remove the cloud folder on all machines
ansible -i inventory all -a "rm -r cloud"

#confirm if done
ansible -i inventory all -a "ls"

#So i don't always have to do 
vi shell.sh

#So my main point is that u dont have to write playbooks all the time u can also write from ansible cli


Now create an inventory files that stores the Ip address of your target servers
#Now go to the ansible controller and create an inventory file

#Most of the time its in a default file

/etc/ansible/hosts/

# But you can do it anywhere for now bc its not always convenient from that location
vim inventory


Cat inventory
172.31.27.109

ansible -i inventory 172.31.27.109

[yellow]
172.31.27.109

You cam sol have multiple server ip addresses here above in the inventory files
#now let's write our first adhoc commands


ansible -i inventory 172.31.27.109
 
#Or if they are in a group already then

Cat inventory
 [yellow]
172.31.27.109

ansible -i inventory yellow -m ping
======================================
#Or if you have them in a group mentioned the name of the group

ubuntu@ip-172-31-4-109:~$ ansible -i inventory webservers -m ping

#ansible also supports all


## Understanding Ad-hoc commands in Ansible
To put simply, Ansible ad hoc commands are one-liner Linux shell commands and playbooks are like a shell script, a collective of many commands with logic.
Ansible ad hoc commands come handy when you want to perform a quick task.
task
# To check the disk space on all hosts in an inventory file
ansible -i inventory all -m shell -a 'df -h'
Or 
ansible -i inventory webservers -m shell -a 'df -h'
# ansible ad hoc command to check the free memory or memory usage of hosts

ansible -i inventory all -a "free -m"


# to find ids on host machines

ansible -i inventory webservers -m shell -a 'id'


# to install apache on all machines

ansible -i inventory webservers -m apt -a 'name=apache2 state=present'




# first create a file touch /tmp/my-file.txt on the control server and push it to all #machines

touch /tmp/my-file.txt 

ansible -i inventory webservers -m copy -a "src=/tmp/my-file.txt dest=/tmp/my-file.txt"

# We change the permissions and ownership on the remote files. Notice we use --become, to elevate the privileges.
ansible -i inventory webservers -m file -a "dest=/tmp/my-file.txt mode=777 owner=root group=root" --become

# We remove the file from the remote servers. Since the file is now owned by root, we need to use elevated privileges.

ansible -i inventory webservers -m file -a "dest=/tmp/my-file.txt mode=777 owner=root group=root" --become

# You can check the status of a specific service on single hosts or server1

ansible -i inventory -m service -a 'name=apache2 state=started'

# Or on servers in a group webservers to check the status of a service

ansible -i inventory webservers -m service -a 'name=nginx state=started'


 Services
 We install NGINX on all hosts in the "appservers" group using the "dnf" module.
 $ ansible appservers -m dnf -a "name=nginx state=present" --become


# To copy a file to all hosts in an inventory file

 ansible -i inventory -m copy -a 'src=/local/path/to/file dest=/remote/path/to/file mode=0644'
# You can check the status of a specific service on single hosts or server1
ansible -i inventory_file server1 -m service -a 'name=apache2 state=started'
Ansible playbooks
This is used for multiple task in devops automation
And you must become root

# make sure the that the group of servers or serve ip referenced is exactly what u entered in the hosts
# make sure you referenced -in inventory this in your playbook as shown below


Vi httpd.yml
- hosts: webservers
  become: true
  tasks:
  - name: Install latest version of Apache 
    apt:
     name: apache2
     update_cache: yes
     state: present


ansible-playbook -i inventory httpd.yml --check

# now add service to the playbook
vim httpd.yml

- hosts: webservers
  become: true
  tasks: