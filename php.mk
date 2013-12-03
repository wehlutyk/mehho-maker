php-pkg.i :
	$(apt_install) php5-fpm php-apc php5-gd php5-mcrypt php5-intl php5-pspell php-xml-parser
	touch $@

php5-fpm-config.i : php-pkg.i utils.i
	$(jinja_copy) $(files_dir)/etc/php5/fpm/php.ini.jinja $(settings) /etc/php5/fpm/php.ini
	mkdir -p /etc/php5/fpm/pool.d
	cp $(files_dir)/etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf
	touch $@

php5-fpm-service.i : php-pkg.i php5-fpm-config.i setup-php5-sqlite2.i php5-sqlite2-config.i
	service php5-fpm restart
	touch $@

php5-sqlite2-pkg.i :
	$(apt_install) libsqlite0 php-pear php5-dev php5-sqlite
	touch $@

setup-php5-sqlite2.i : utils.i php-pkg.i php5-sqlite2-pkg.i sqlite.i
	aptitude search "~i php5-sqlite2" | grep -q php5-sqlite2 || $(scripts_dir)/setup-php5-sqlite2 > /tmp/setup-php5-sqlite2-$$(date +%Y-%m-%d_%H-%M-%S).log
	touch $@

php5-sqlite2-config.i : setup-php5-sqlite2.i
	cp $(files_dir)/etc/php5/mods-available/sqlite.ini /etc/php5/mods-available/sqlite.ini
	ln -sf ../mods-available/sqlite.ini /etc/php5/conf.d/20-sqlite.ini
	touch $@

php.i : php-pkg.i php5-fpm-config.i php5-fpm-service.i php5-sqlite2-pkg.i setup-php5-sqlite2.i php5-sqlite2-config.i
	@echo "\n----- [info] php installed\n"
	touch $@
