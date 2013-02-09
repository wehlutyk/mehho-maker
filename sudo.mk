sudo-pkg.i :
	$(apt_install) sudo
	touch $@

setup-sudoers.i :
	$(jinja_run) $(scripts_dir)/setup-sudoers.jinja $(settings)
	touch $@

sudo.i : setup-sudoers.i sudo-pkg.i
	@echo "\n----- [info] sudo installed\n"
	touch $@
