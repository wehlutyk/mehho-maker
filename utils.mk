utils-pkg.i :
	$(apt_install) acpid autojump build-essential byobu bzr checkinstall colordiff curl dcfldd debconf-utils debian-goodies deborphan dnsutils dstat etckeeper ethtool expect finger git htop ifstat iftop imagemagick iotop ipcalc iperf lsb-release lvm2 mcrypt molly-guard mtr-tiny mutt nmap parted psmisc pwauth pwgen python-jinja2 python-pip python-virtualenv python-yaml rsync subversion sysstat tcpdump tree unrar-free unzip vim virtualenvwrapper zsh
	touch $@

muttrc-config.i : utils-pkg.i
	cp $(files_dir)/etc/Muttrc /etc/Muttrc
	touch $@

jinja2-cli.i : utils-pkg.i
	virtualenv --system-site-packages $(jinja_env)
	$(workon_jinja) && pip install jinja2-cli
	touch $@

$(settings) : jinja2-cli.i $(settings_jinja)
	$(workon_jinja) && $(scripts_dir)/setup-jinja-settings $(settings_jinja) $(settings)
	# No need to touch a file here since the script creates that file

utils.i : utils-pkg.i muttrc-config.i jinja2-cli.i $(settings)
	@echo "\n----- [info] utils installed\n"
	touch $@
