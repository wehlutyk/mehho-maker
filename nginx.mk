nginx-pkg.i :
	$(apt_install) nginx
	touch $@

nginx-files-clean.i : nginx-pkg.i
	rm -f /etc/nginx/sites-enabled/default
	rm -rf /etc/nginx/conf.d
	rm -f /var/www/index.html
	touch $@

nginx-config.i : nginx-pkg.i nginx-files-clean.i
	cp $(files_dir)/etc/nginx/nginx.conf /etc/nginx/nginx.conf
	touch $@

nginx-vhosts-config.i : nginx-config.i php.i
	$(jinja_run) $(scripts_dir)/setup-nginx-vhosts.jinja $(settings)
	touch $@

nginx-service.i : nginx-config.i nginx-vhosts-config.i openssl.i
	service nginx restart
	touch $@

ufw-allow-http.i : ufw-pkg.i
	ufw status | grep -qE "80 +ALLOW +Anywhere" || ufw allow 80
	touch $@

ufw-allow-https.i : ufw-pkg.i
	ufw status | grep -qE "443 +ALLOW +Anywhere" || ufw allow 443
	touch $@

fcgiwrap-pkg.i : nginx-pkg.i
	$(apt_install) fcgiwrap
	touch $@

fcgiwrap-config.i : fcgiwrap-pkg.i
	cp $(files_dir)/etc/nginx/fcgiwrap.conf /etc/nginx/fcgiwrap.conf
	touch $@

fcgiwrap-service.i : fcgiwrap-config.i
	service fcgiwrap restart
	touch $@

nginx.i : nginx-pkg.i nginx-files-clean.i nginx-config.i nginx-vhosts-config.i nginx-service.i ufw-allow-http.i ufw-allow-https.i fcgiwrap-pkg.i fcgiwrap-config.i fcgiwrap-service.i
	@echo "\n----- [info] nginx installed\n"
	touch $@
