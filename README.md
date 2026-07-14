# Ansible_projects
Ansible is a radically simple, open-source IT automation engine used for configuration management, application deployment, and cloud provisioning. Its agentless architecture connects to remote nodes via standard OpenSSH without requiring extra software on the target systems.

Project workflow:

Provision 3 or 4 EC2 instances using terraform. The Terraform script should name 1 of the servers  - ansible contoller, 2nd server - remote server 1 and 3rd server - remote server 2.

1. Log into AWS console.
2. Check the created EC2 instances are successfully created.
3. Click on the instance name ansible controller.
4. Using EC2 connect, click on ec2 instance connect to access the terminal.
5. To ensure it is the ansible controller - type ansible --version.
6. The following are extra unnecessary steps:
6a. Type cd .ssh (to check the contents)
6b. Type ls (to show the authorised key)
6c. Type ssh-keygen (this automatically creates the private ad public ids)
7. Press enter 3 times until a private and public key is created in the ssh folder.
8. Then cd to the ssh folder
9. Type cd .ssh
10.Type  ls (this will show the private and the public ids) i.e. authorised_key, id_ed25519, id-ed22519.pub
11. Next connect the public id of the ansible controller to the remote servers.
12. Type cat, the copy and paste the id_ed25519.pub
13. copy the code generated.
14. Note the ip address of the ansible controller.


1. Click on the the remote server 1 in EC2.
2. Connect to ec2 instance connect.
3. Type cd .ssh and press enter
4. Type ls
5. copy the authorised key
6. Type vi and paste the authorised key
7. A key is generated
8. Press i and scroll to the end of the key in step 7.
9. paste the code generated from the ansible controller.
10. Then save using Esc:wq!
11. Note the ip address created for remote server 1.

Repeat steps 1-11. Note the ip address for remote server 2.

For both remote servers 1 and 2:
1. Type cd ..
2. Type clear for both.

For the ansible controller
1. Type cd ..
2. To ensure there is a connection to the ansible controller, 
3. Type ping google.com.
4. Click ctrl+ c to stop the pings to google.
5.Type clear

vi edits the contents of a folder/directory
cat shows the contents of a folder/directory

For ansible playbook:

1. Create an inventory to create a group for the servers.
2. Use [] and type inside the box - webservers.
3. copy and paste the two remote server ip addresses.
4. save the file Esc:wq!
5. Test we can ping or ssh to the remote servers, type 
ansible -i inventory webservers -m ping
6. It should show success in green for both servers.
7. In Vs code, create the folder Ansible playbook.
8. Create the file, startnginx.yaml and enter the required script. Copy the script.
9. In Ansible controller ip, create a file; vi startnginx.yaml
10. Type i
11. Paste the code in step 8. 
12. Save the code using Esc:wq!
13. Type the command; ansible-playbook -i inventory startnginx.yaml
14. ssh to one of the remote servers, type ssh ip address of remote server 1
15. check nginx is there, sudo systemctl status nginx
16. Go back to ansible controller, type exit.
17. To stop nginx running, in the ansible controller, create the file using;
vi stopnginx.yaml
18. Follow steps 8-14.
19. Then type, ansible-playbook -i inventory stopnginx.yaml
20. To purge nginx in each remote server, sudo apt purge nginx.
21. Repeat the same process for apache2.
22. Repeat the same process for jenkins.


<img width="824" height="359" alt="Image" src="https://github.com/user-attachments/assets/1e4ae767-30e4-4a38-a288-63471deb10a0" />


<img width="455" height="182" alt="Image" src="https://github.com/user-attachments/assets/9684c270-562a-493f-984d-022b32d695fd" />

<img width="746" height="414" alt="Image" src="https://github.com/user-attachments/assets/8068e0f7-4053-46b7-a8b5-50c73b71bdf7" />


Challenges:

1. Port 80 to allow ingress rules for http was not included in the terraform files. Hence, Nginx in the brower was not downloaded successfully.

2. Issues with Jenkins code - 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Starting Ansible roles

Ansible roles are modular, reusable bundles of automation content. They group related tasks, variables, templates, and files into a strict directory structure. Instead of writing one massive playbook, roles let you break complex configurations into distinct, manageable parts that can be easily reused and shared.

Why Use Roles?
1. Modularity: You can break down large playbooks into smaller, focused chunks.
2. Reusability: You can write a role once (e.g., to install Nginx or set up a database) and use it across multiple projects.
3. Standardization: Roles enforce a predictable folder layout, making it easy for different engineers to understand your code.
4. Shareability: You can publish and download roles via Ansible Galaxy.


