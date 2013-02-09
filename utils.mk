utils-pkg.i :
	$(apt_install) acpid build-essential byobu bzr checkinstall colordiff dcfldd debian-goodies deborphan dstat etckeeper ethtool finger git htop ifstat iftop imagemagick iotop ipcalc iperf lsb-release mcrypt molly-guard mtr-tiny mutt nmap parted psmisc pwauth pwgen python-jinja2 python-pip python-virtualenv python-yaml rsync subversion sysstat tcpdump tree unrar-free unzip vim virtualenvwrapper zsh
	touch $@

muttrc-config.i : utils-pkg.i
	cp $(files_dir)/etc/Muttrc /etc/Muttrc
	touch $@

jinja2-cli.i : utils-pkg.i
	virtualenv --system-site-packages $(jinja_env)
	$(workon_jinja) && pip install jinja2-cli
	touch $@

utils.i : utils-pkg.i muttrc-config.i jinja2-cli.i
	@echo "\n----- [info] utils installed\n"
	touch $@
