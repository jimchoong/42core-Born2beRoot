# General info
What is a virtual machine (VM)?
A virtual machine is an emulation of a computer system. 
It is an isolated environment created in your system.
A universe within a universe, where the child universe is shares the same resources of the parent universe.

Why use a VM?
- useful in testing in an isolated environment - dissecting and studying the behavior of a computer virus
- testing in other architectures - for eg testing Linux app in a Linux VM with the same machine

Why Debian?
- CentOS is getting phased out
- Debian's ability to upgrade from one stable release to another - makes maintenance of server systems easier
- https://www.openlogic.com/blog/centos-vs-debian
- 
CentOS vs Debian
- CentOS a replica of Red Hat Enterprise Linux, the most widely used system in corporate IT
- Debian has more packages
- and other differences as summarised here https://www.educba.com/centos-vs-debian/

apt vs aptitude
- Advanced Package Tool (apt) is a software user interface (UI) that handles installation and removal of software on Debian
- apt is a front-end to dpkg 
- https://en.wikipedia.org/wiki/APT_(software)
- aptitude is a front-end UI of apt, offering text-based UI and more functionality
- https://en.wikipedia.org/wiki/Aptitude_(software)

What is AppArmor (AA)?
It is a Linux application (apps) security system that protects the operating system (OS) and apps.
How does AA protect?
- defining resources an app has access to
- defining privileges of the app.
https://gitlab.com/apparmor/apparmor/-/wikis/home

# Installation of Debian VM
1. Creating a Debian VM, Debian installation, disk partitioning
2. Installing sudo, configuring sudoer
3. SSH, UFW setup
4. Cron, monitoring.sh
5. Set up new user and new group 
