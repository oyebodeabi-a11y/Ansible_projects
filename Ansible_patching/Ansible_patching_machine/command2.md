## The goal of this project is to explain about how to do OS patching using ansible playbook.

### What is patch management?

Patch management is the process of locating security flaws throughout the organisation and fixing them by applying updates to servers, computers, software, and other technology systems.

###  Why is patch management important?

Patch management helps businesses maintain network security and lower cyber risk by repairing vulnerabilities on assets that are vulnerable to an attack.

###  What is the patch management process?

Make an inventory of all assets to determine which systems you have and which need to be patched.
Sort vulnerabilities according to priority to identify which assets require immediate patching and faster remediation.

Patch your systems to protect them from a potential cyber-attack.
Track your patch posture and improve your patching strategy by reporting progress.
System administrators and developers must keep their systems up to date and apply all security patches. Patching packages is a chore that no one enjoys. There are three different types of patching they are

Patch all OS packages to the latest version.
Apply all security patches.
Apply all bugfix patches.

###  Why do we need patch management?

Prevention of ransomware: Patch management is essential to preventing ransomware assaults. Patching your network as soon as possible will help prevent cybercriminals from taking advantage of weaknesses in it and threatening your company’s operations.

Compliance: Due to the ongoing increase in cyberattacks, authorities
frequently demand that organisations adhere to particular standards and best practices for system configuration. Patch management must be
implemented in order to adhere to current security regulations.

Enhanced functionality and performance: Patch management is more than just resolving software bugs. Updates from software patches frequently bring enhanced functionality and new features.

Identification of obsolete software: Patch management solutions are capable of locating out-of-date or unsupported software on your network. These systems must be retired since they could endanger company operations’ security.

###  Best practices for patch management

Determine patching priorities based on the value of your assets to your company and the risk of a breach.
Using an automated patch management system, you can quickly find and apply patches.
Use reports to track your patch management strategy and encourage improvements in key metrics.
Install critical updates as soon as possible to keep your company’s systems secure from intrusion.
Establish a clear patch workflow to ensure that your systems are patched on a regular basis and that emergency patches are applied as soon as possible.
Teams should be held accountable for motivating risk owners to contribute to patch management.
Ever pondered how to apply a patch, restart your computer, and carry on with your work? If so, Ansible is a straightforward configuration management tool that can simplify some of the most difficult tasks. For instance, system administration duties that can be challenging, require hours to finish, or have intricate security requirements. Patching systems is, in my opinion, one of the most difficult aspects of being a sysadmin. You have to shift into high gear to plug security holes whenever you receive a Common Vulnerabilities and Exposures (CVE) notification or an Information Assurance Vulnerability Alert (IAVA), as required by security. Now let’s get going.

Patching used to take the operations team an entire weekend; now, it only takes two hours. All of this is due to ansible playbooks. Through module packaging, Ansible can speed up system patching times. Let’s update the system using the yum module as an example. Ansible can update, install from a different location, remove, or install. Now let’s get going.

###  Prerequisites

server.cnl.com — 1 CPU — 1GB RAM  — Ansible Server
node1.cnl.com — 1 CPU
RAM  — Ansible Client 1
node2.cnl.com — 1 CPU — 1GB RAM  — Ansible Client 2
from ansible server login as an ansible user execute below command

ansible all -m ping

###  this above ping command should return with ping / pong green colour.

We are creating an YAML file named below for patching.

vim patch.yml
We are going to have the below code there are nine tasks are being executed.

### Task 1 — Installing httpd

- name: install httpd
  yum:
   name: httpd
   state: latest
  delegate_to: node2

###  Task 2 — Check whether application and database are running

- name: "Check whether application and database are running"
    script: /home/ansible/ansible_demo/appcheck.sh
    args:
      executable: /bin/bash
    ignore_errors: true
    register: application_process_check
Here there is a small script to check the application and database below are the contents of it.

#!/bin/bash
###  to check application status
ps cax | egrep "apache|http|pmon|oracle"| grep -v grep >/dev/null
if [ $? -eq 0 ]
 then
 echo "Process is running."
 else
 echo "Process is not running."
fi

###  Task 3 — Check whether the application is stopped and start the patching

- name: "Will check and start patching on linux servers"
    fail: msg='{{ inventory_hostname }} have running Application. Please stop application and then proceed with patch.'
    when: application_process_check.stdout == "process is running"

###  Task 4 — Applying patches to the server.

- name: "Applying patches to the server"
    yum: name=kernel state=latest
    when: application_process_check.stdout == "Process is not running.\r\n" and ansible_distribution == "CentOS" or ansible_distribution == "RedHat"
    register: patch_update

###  Task 5 — Check if reboot required

- name: "Check if reboot required"
    shell: KERNEL_NEW=$(rpm -q --last kernel |head -1 | awk '{print $1}'|sed 's/kernel-//'); KERNEL_NOW=$(uname -r); if [[ $KERNEL_NEW != $KERNEL_NOW ]]; then echo "reboot needed"; else echo "reboot not needed"; fi
    ignore_errors: true
    register: reboot_status




    ### =========================

The palybook has now been successfully run, and the patching has been completed. Patch management is the process of updating software, drivers, and firmware to prevent vulnerabilities. Effective patch management also ensures that systems run at peak performance, increasing productivity.

###  Points to consider when performing patch management.

Set patching priorities based on the importance of your assets to
your business and the risk of a breach.
Find and apply patches quickly by using an automated patch management system.
Utilise reports to monitor your patch management strategy and encourage advancements in important metrics like MOVA and MTTP.

Install important updates as soon as you can to keep your company’s systems safe from intrusion.
To guarantee that your systems are patched on a regular basis and that
emergency patches are applied promptly, establish a clear patch workflow.

