ntp-pkg.i :
	$(apt_install) ntp
	touch $@

ntp-conf.i : ntp-pkg.i
	cp $(files_dir)/etc/ntp.conf /etc/ntp.conf
	touch $@

ntp-service.i : ntp-conf.i
	service ntp restart
	touch $@

ntp.i : ntp-pkg.i ntp-conf.i ntp-service.i
	@echo "\n----- [info] ntp installed\n"
	touch $@
