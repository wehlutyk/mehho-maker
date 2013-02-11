server-files-dir.i :
	mkdir -p /srv/stuff/data
	mkdir -p /srv/stuff/www-public
	touch $@

server-files-sharedfolders-perms.i : server-files-dir.i users.i
	cp $(files_dir)/usr/local/bin/sharedfolders-perms /usr/local/bin/sharedfolders-perms
	chmod 755 /usr/local/bin/sharedfolders-perms
	touch $@

server-files-cron.i : server-files-dir.i server-files-sharedfolders-perms.i
	echo "*/15 * * * * root /usr/local/bin/sharedfolders-perms" > /etc/cron.d/sharedfolders-perms
	touch $@

server-files.i : server-files-dir.i server-files-sharedfolders-perms.i server-files-cron.i
	@echo "\n----- [info] server-files installed\n"
	touch $@
