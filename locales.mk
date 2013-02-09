locales-pkg.i :
	$(apt_install) locales
	touch $@

locale-gen-config.i : locales-pkg.i
	cp $(files_dir)/etc/locale.gen /etc/locale.gen
	touch $@

locale-gen-cmd.i : locale-gen-config.i
	/usr/sbin/locale-gen
	touch $@

locales.i : locales-pkg.i locale-gen-config.i locale-gen-cmd.i
	@echo "\n----- [info] locales installed\n"
	touch $@
