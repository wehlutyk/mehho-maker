owncloud-pkg.i : utils.i php.i
	$(apt_install) smbclient libcurl3 php5-curl
	touch $@

owncloud-setup.i : utils.i
	$(jinja_run) $(scripts_dir)/setup-owncloud.jinja
	touch $@
