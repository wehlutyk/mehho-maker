owncloud-pkg.i : utils.i php.i
	$(apt_install) smbclient libcurl3 php5-curl
	touch $@

owncloud-setup.i : utils.i
	$(jinja_run) $(scripts_dir)/setup-owncloud.jinja $(settings)
	touch $@

owncloud.i : owncloud-pkg.i owncloud-setup.i
	@echo "\n----- [info] owncloud installed\n"
	touch $@
