sudo-pkg.i :
	$(apt_install) sudo
	touch $@

setup-sudoers.i : utils.i sudo-pkg.i
	$(jinja_run) $(scripts_dir)/setup-sudoers.jinja $(settings)
	touch $@

sudo.i : setup-sudoers.i sudo-pkg.i
	@echo "\n----- [info] sudo installed\n"
	touch $@
