roundcube.i : php.i sqlite.i aspell.i utils.i
	$(jinja_run) $(scripts_dir)/setup-roundcube.jinja $(settings) > /tmp/setup-roundcube-$$(date +%Y-%m-%d_%H-%M-%S).log
	@echo "\n----- [info] roundcube installed\n"
	touch $@
