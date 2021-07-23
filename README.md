# General info
### What is a virtual machine (VM)?
A virtual machine is an emulation of a computer system. 
It is an isolated environment created in your system.
A universe within a universe, where the child universe is shares the same resources of the parent universe.

### Why use a VM?
- useful in testing in an isolated environment - dissecting and studying the behavior of a computer virus
- testing in other architectures - for eg testing Linux app in a Linux VM with the same machine

### Why Debian?
- CentOS is getting phased out
- Debian's ability to upgrade from one stable release to another - makes maintenance of server systems easier
- https://www.openlogic.com/blog/centos-vs-debian

### CentOS vs Debian
- CentOS a replica of Red Hat Enterprise Linux, the most widely used system in corporate IT
- Debian has more packages
- and other differences as summarised here https://www.educba.com/centos-vs-debian/

### apt vs aptitude
- Advanced Package Tool (apt) is a software user interface (UI) that handles installation and removal of software on Debian
- apt is a front-end to dpkg 
- https://en.wikipedia.org/wiki/APT_(software)
- aptitude is a front-end UI of apt, offering text-based UI and more functionality
- https://en.wikipedia.org/wiki/Aptitude_(software)

### What is AppArmor (AA)?
It is a Linux application (apps) security system that protects the operating system (OS) and apps.
How does AA protect?
- defining resources an app has access to
- defining privileges of the app.
https://gitlab.com/apparmor/apparmor/-/wikis/home

# Setting up Debian VM
1. Debian installation, disk partitioning
2. Installing sudo, configuring sudoer
3. Installing SSH, UFW
4. Setting password policy
5. Cron set up, monitoring.sh
6. Set up new user and new group 


## 1. Debian installation, disk partitioning
Installation of Debian, disk partitioning was done according to set up for mandatory portion. 
Please watch [here](https://youtu.be/r_UuqrbwgtI).

## 2. Installing sudo, configuring sudoer
Steps recorded in video [here](https://youtu.be/r_UuqrbwgtI)

### Why use sudo?
- not advisable to do superuser tasks using root; may inflict permanent damage to system (deleting sys files, locking out admin rights, etc)
- sudo has log to to keep track of all sudo cmd used by users

### Why use visudo?
- safer way to edit sudo files

### What if I disabled root user during installation and don't have sudo installed?
- this won't happen; if you disabled root user, then sudo is automatically installed. If root is enabled, sudo will not be installed by default.

### If no user was created during installation?
- you will log in as root user by default

### What is sudoer?
Sudoer file is the policy that determines a user's sudo privileges.
https://www.sudo.ws/man/1.8.15/sudoers.man.html

### Additional resources
- Editing sudoer file https://www.garron.me/en/linux/visudo-command-sudoers-file-sudo-default-editor.html

## Setting up sudo
1. Login as root user
`su -`
2. Update apt packages
`apt update`
3. Install sudo
`apt install sudo`
4. Check if installed successfully
`dpkg -s sudo | grep Status`
5. Create user (if not already created during installation)
`adduser $username`
6. Add user to sudo group
`adduser $username sudo`
7. Exit root
`exit`
8. Relogin user for sudo to come into effect
`su - $username`

## Setting up sudoer
1. Edit sudoer file
`sudo visudo`
2. Change sudoer settings:
Authentication using sudo set to 3 (by default it is set to 3)
`Defaults password_tries=3`

Display custom password error message
`Defaults badpass_message="$custom_message"`
(Interestingly, there is an insult option for bad password message)

Log all sudo inputs and outputs
`Defaults log_input, log_output`

Set path for sudo i/o log
`Defaults iolog_dir="/var/log/sudo/"`

Enable TTY mode
`Defaults requiretty`

Restrict path used by sudo command
`Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"`

## 3. Installing SSH, UFW

### What is SSH?
SSH stands for Secure SHell protocol, a network protocol that gives sysadmins a secure way to access remote assets over unsecured network. SSH provides password or public-key based authentication and encrypts connections between two endpoints.
https://www.keyfactor.com/blog/ssh-protocol/

### Installing SSH
1. Update apt package
`sudo apt update`
2. Install OpenSSH server
`sudo apt install openssh-server`
3. Check if successfully installed
`dpkg -s openssh-server | grep Status`
4. Configure SSH
`sudo vi /etc/ssh/sshd_config`

Change `#Port 22` to `Port 4242` to change port to 4242
Change `#PermitRootLogin prohibit-password` to `PermitRootLogin no` to disable SSH root login

5. Restart SSH for changes to take effect
`sudo service ssh restart`
6. Check SSH status
`sudo systemctl status ssh`

### Installing UFW
1. Install UFW
`sudo apt install ufw`
2. Check firewall status
`sudo ufw status`
3. Enable UFW
`sudo ufw enable`
4. Set firewall to only allow port 4242
`sudo ufw allow 4242`
5. Delete port that was allowed
`sudo ufw delete $rule_number`

### Connecting via SSH
1. Get ip address of VM
`hostname -I`
2. Check Virtual Box network setting (for demonstration, I used 'Bridged Adapter')
3. Connect to VM with another PC on local network
`ssh $username@$ip4_address -p 4242`
4. Logout
`exit`

## 4. Setting password policy

### Setting password age policy
1. Edit password age config file
`sudo vi /etc/login.defs`
2. Change settings

Set password expiry to 30 days
`PASS_MAX_DAYS 99999` to `PASS_MAX_DAYS 30`

Set minimum days between password changes
`PASS_MIN_DAYS 0` to `PASS_MIN_DAYS 2`

Set days for showing password expiry warning to 7 days
`PASS_WARN_AGE 7`

### Setting password quality policy
1. Install password quality check library
`sudo apt install libpam-pwquality`
2. Edit password quality config file
`sudo vi /etc/pam.d/common-password`
3. Change settings

Prompt user 3 times for password retries
`retry=3`

Set minimum password length to 10
`minlen=10`

Set maximum repeating characters in password to 3
`maxrepeat=3`

Require at least one upper char, one digit
`ucredit=-1 dcredit=-1`
(> 0 to set maximum characters, <0 to set minimum characters)

Set number of characters in the new password that must have at least 7 characters not part of former password
`difok=7`

Ensure password does not contain username
`reject_username`

Enforce root password to follow this police
`enforce_for_root`

Combining the configuration to one line
`password requisite     pam_pwquality.so retry=3 minlen=10 maxrepeat=3 ucredit=-1 dcredit=-1 difok=7 reject_username enforce_for_root`

## 5. Cron set up, monitoring.sh

### What is cron?
Cron is a time-based job scheduler in Unix-like system. The cron jobs are saved as crontab files for each user.

Set up process can be watched [here](https://youtu.be/JwCUnzgaIh0)

Setting cron job as root
`sudo crontab -u root -e`

To set up cron job to broadcast every 10 minutes
`*/10 * * * * bash $path/to/monitoring.sh`

To check scheduled cron job
`sudo crontab -u root -l`

Refer to monitoring.sh for broadcast script.

## 6. Set up new user and new group
To create new user
`sudo adduser $username`

Get user password info
`sudo chage -l $username`

Force user to reset password on next login
`passwd --expire $username`

Make new group
`sudo addgroup $groupname`

Add user to group
`sudo adduser $username $groupname`

Check all members of group
`getent group $groupname`

Remove user from group
`sudo deluser $username $groupname`

### Change hostname
`sudo nano /etc/hostname`
