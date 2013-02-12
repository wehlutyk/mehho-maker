email-filtering-pkg.i : postfix-pkg.i dovecot-pkg.i
	# 'rar', 'unrar', and 'lha' are missing in this package list (not in the repos)
	$(apt_install) amavisd-new clamav-daemon clamav-freshclam spamassassin opendkim postfix-policyd-spf-python pyzor razor arj cabextract cpio nomarch pax zip
	touch $@

email-filtering-config.i : email-filtering-pkg.i utils.i
	getent group clamav | sed 's/[^:]*://' | grep -q amavis || adduser amavis clamav
	getent group amavis | sed 's/[^:]*://' | grep -q clamav || adduser clamav amavis
	cp $(files_dir)/etc/amavis/conf.d/15-content_filter_mode /etc/amavis/conf.d/15-content_filter_mode
	cp $(files_dir)/etc/amavis/conf.d/20-debian_defaults /etc/amavis/conf.d/20-debian_defaults
	$(jinja_copy) $(files_dir)/etc/amavis/conf.d/50-user.jinja $(settings) /etc/amavis/conf.d/50-user
	cp $(files_dir)/etc/default/spamassassin /etc/default/spamassassin
	touch $@

email-filtering-service.i : email-filtering-config.i
	freshclam
	service amavis restart
	service clamav-daemon restart
	service clamav-freshclam restart
	service spamassassin restart
	touch $@

email-filtering.i : email-filtering-pkg.i email-filtering-config.i email-filtering-service.i
	@echo "\n----- [info] email-filtering installed\n"
	touch $@
