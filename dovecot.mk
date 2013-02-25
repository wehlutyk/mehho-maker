dovecot-pkg.i :
	$(apt_install) dovecot-imapd dovecot-pop3d dovecot-sieve dovecot-managesieved
	touch $@

dovecot-config.i : dovecot-pkg.i utils.i
	cp $(files_dir)/etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf
	cp $(files_dir)/etc/dovecot/conf.d/10-master.conf /etc/dovecot/conf.d/10-master.conf
	$(jinja_copy) $(files_dir)/etc/dovecot/conf.d/10-ssl.conf.jinja $(settings) /etc/dovecot/conf.d/10-ssl.conf
	cp $(files_dir)/etc/dovecot/conf.d/15-lda.conf /etc/dovecot/conf.d/15-lda.conf
	cp $(files_dir)/etc/dovecot/conf.d/20-managesieve.conf /etc/dovecot/conf.d/20-managesieve.conf
	touch $@

ufw-allow-imap.i : ufw-pkg.i
	ufw status | grep -qE "143 +ALLOW +Anywhere" || ufw allow 143
	touch $@

ufw-allow-pop3.i : ufw-pkg.i
	ufw status | grep -qE "110 +ALLOW +Anywhere" || ufw allow 110
	touch $@

ufw-allow-sieve.i : ufw-pkg.i
	ufw status | grep -qE "4190 +ALLOW +Anywhere" || ufw allow 4190
	touch $@

dovecot-service.i : dovecot-pkg.i dovecot-config.i ufw-allow-imap.i ufw-allow-pop3.i ufw-allow-sieve.i email-filtering.i openssl.i prosody-config.i
	service dovecot restart
	touch $@

dovecot.i : dovecot-pkg.i dovecot-config.i ufw-allow-imap.i ufw-allow-pop3.i ufw-allow-sieve.i dovecot-service.i
	@echo "\n----- [info] dovecot installed\n"
	touch $@
