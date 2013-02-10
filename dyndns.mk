dyndns.i : utils.i
	$(jinja_run) $(scripts_dir)/setup-dyndns.jinja $(settings)
	@echo "\n----- [info] dyndns installed\n"
	touch $@
