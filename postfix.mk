postfix-pkg.i : utils.i
	# Set selections to avoid being asked questions during install
	# Configuration is done later on anyway
	debconf-set-selections <<< "postfix postfix/mailname string placeholder.local"
	debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
	$(apt_install) postfix
	touch $@

postfix-config.i : postfix-pkg.i utils.i
	$(jinja_copy) $(files_dir)/etc/postfix/main.cf.jinja $(settings) /etc/postfix/main.cf
	cp $(files_dir)/etc/postfix/master.cf /etc/postfix/master.cf
	$(jinja_copy) $(files_dir)/etc/mailname.jinja $(settings) /etc/mailname
	$(jinja_copy) $(files_dir)/etc/aliases.jinja $(settings) /etc/aliases
	touch $@

postfix-newaliases.i : postfix-config.i
	newaliases
	touch $@

ufw-allow-smtp.i : ufw-pkg.i
	ufw status | grep -qE "25 +ALLOW +Anywhere" || ufw allow 25
	touch $@
	
ufw-allow-smtp2525.i : ufw-pkg.i
	ufw status | grep -qE "2525 +ALLOW +Anywhere" || ufw allow 2525
	touch $@

postfix-service.i : postfix-pkg.i ufw-allow-smtp.i ufw-allow-smtp2525.i postfix-config.i postfix-newaliases.i mailman-postfix-transport.i
	service postfix restart
	touch $@

postfix.i : postfix-pkg.i postfix-config.i postfix-newaliases.i ufw-allow-smtp.i ufw-allow-smtp2525.i postfix-service.i
	@echo "\n----- [info] postfix installed\n"
	touch $@
