mailman-pkg.i : postfix-pkg.i utils.i
	debconf-set-selections $(files_dir)/var/cache/debconf/mailman.seeds && $(apt_install) mailman
	touch $@

mailman-config.i : mailman-pkg.i utils.i
	# This reconfiguration needs to be done twice, since  with apt-get install
	# not everything seems to be taken into account.
	debconf-set-selections $(files_dir)/var/cache/debconf/mailman.seeds && dpkg-reconfigure -f noninteractive mailman
	$(jinja_copy) $(files_dir)/etc/mailman/mm_cfg.py.jinja $(settings) /etc/mailman/mm_cfg.py
	touch $@

mailman-postfix-transport.i : postfix-pkg.i mailman-config.i utils.i
	$(jinja_copy) $(files_dir)/etc/postfix/transport.jinja $(settings) /etc/postfix/transport
	postmap -v /etc/postfix/transport
	touch $@

mailman-setup.i : mailman-config.i utils.i
	$(jinja_run) $(scripts_dir)/setup-mailman.jinja $(settings)
	check_perms -f
	touch $@

mailman-service.i : mailman-config.i mailman-postfix-transport.i mailman-setup.i postfix-service.i
	service mailman restart
	touch $@

mailman-nginx-config.i : nginx-config.i utils.i
	$(jinja_run) $(scripts_dir)/setup-mailman-nginx.jinja $(settings)
	touch $@

mailman.i : mailman-pkg.i mailman-config.i mailman-postfix-transport.i mailman-setup.i mailman-service.i mailman-nginx-config.i
	@echo "\n----- [info] mailman installed\n"
	touch $@
