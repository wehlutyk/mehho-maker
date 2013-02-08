apticron-pkg.i : 
	$(apt_install) apticron
	touch $@

apticron.i : apticron-pkg.i
	@echo "\n----- [info] apticron installed\n"
	touch $@
