fail2ban-pkg.i :
	$(apt_install) fail2ban
	touch $@

fail2ban-config.i : fail2ban-pkg.i
	cp $(files_dir)/etc/fail2ban/jail.local /etc/fail2ban/jail.local
	touch $@

fail2ban-service.i : fail2ban-config.i
	service fail2ban restart
	touch $@

fail2ban.i : fail2ban-pkg.i fail2ban-config.i fail2ban-service.i
	@echo "\n----- [info] fail2ban installed\n"
	touch $@
