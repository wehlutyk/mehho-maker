unattended-upgrades-pkg.i :
	$(apt_install) unattended-upgrades
	touch $@

unattended-upgrades-config.i : unattended-upgrades-pkg.i
	cp $(files_dir)/etc/apt/apt.conf.d/10periodic /etc/apt/apt.conf.d/10periodic
	cp $(files_dir)/etc/apt/apt.conf.d/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
	touch $@

unattended-upgrades.i : unattended-upgrades-pkg.i unattended-upgrades-config.i
	@echo "\n----- [info] unattended-upgrades installed\n"
	touch $@
