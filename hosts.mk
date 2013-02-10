hosts.i : utils.i
	$(jinja_copy) $(files_dir)/etc/hosts.jinja $(settings) /etc/hosts
	@echo "\n----- [info] hosts installed\n"
	touch $@
