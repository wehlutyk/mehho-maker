etherpad-pkg.i : utils-pkg.i
	aptitude search "~i nodejs" | grep -q nodejs || $(scripts_dir)/setup-nodejs
	ls -1 /usr/share | grep -q etherpad-lite || git clone --branch master https://github.com/ether/etherpad-lite.git /usr/share/etherpad-lite
	touch $@

etherpad-user.i :
	getent passwd | grep -q "^etherpad-lite:" || adduser --system --group --home /usr/share/etherpad-lite --no-create-home --disabled-password --disabled-login etherpad-lite
	touch $@

etherpad-config.i : etherpad-user.i utils.i
	# Update safeRun.sh script
	sed -i 's/^EMAIL_ADDRESS=.*$$/EMAIL_ADDRESS="root@localhost"/' /usr/share/etherpad-lite/bin/safeRun.sh
	# Create data folder
	mkdir -p /home/srv/etherpad-lite
	chown -R etherpad-lite:etherpad-lite /home/srv/etherpad-lite
	# Add log folder
	mkdir -p /var/log/etherpad-lite
	chown -R etherpad-lite:etherpad-lite /var/log/etherpad-lite
	# Install settings, but keep it owned by root so nothing bad happens
	chown -R etherpad-lite:etherpad-lite /usr/share/etherpad-lite
	mkdir -p /etc/etherpad-lite
	$(jinja_copy) $(files_dir)/etc/etherpad-lite/settings.json.jinja $(settings) /etc/etherpad-lite/settings.json
	ls /usr/share/etherpad-lite/settings.json || ln -s /etc/etherpad-lite/settings.json /usr/share/etherpad-lite/settings.json
	touch $@

etherpad-init.i : etherpad-config.i
	cp $(files_dir)/etc/init.d/etherpad-lite /etc/init.d/
	chmod +x /etc/init.d/etherpad-lite
	update-rc.d etherpad-lite defaults
	touch $@

etherpad-sqlite3.i : etherpad-config.i sqlite.i
	# Make sure sqlite3 dependency will work
	ls -1 /usr/share/etherpad-lite/node_modules | grep -q sqlite3 || (cd /usr/share/etherpad-lite && sudo -u etherpad-lite npm install sqlite3)
	touch $@

etherpad-plugins.i : etherpad-config.i etherpad-sqlite3.i
	# ep_adminpads
	ls -1 /usr/share/etherpad-lite/node_modules | grep -q ep_adminpads || (cd /usr/share/etherpad-lite && sudo -u etherpad-lite npm install ep_adminpads)
	# ep_doi
	ls -1 /usr/share/etherpad-lite/node_modules | grep -q ep_doi || (cd /usr/share/etherpad-lite && sudo -u etherpad-lite npm install ep_doi)
	# ep_help_bubbles
	ls -1 /usr/share/etherpad-lite/node_modules | grep -q ep_help_bubbles || (cd /usr/share/etherpad-lite && sudo -u etherpad-lite npm install ep_help_bubbles)
	# ep_previewimages
	ls -1 /usr/share/etherpad-lite/node_modules | grep -q ep_previewimages || (cd /usr/share/etherpad-lite && sudo -u etherpad-lite npm install ep_previewimages)
	# ep_linkify
	ls -1 /usr/share/etherpad-lite/node_modules | grep -q ep_linkify || (cd /usr/share/etherpad-lite && sudo -u etherpad-lite npm install ep_linkify)
	# ep_email_notifications
	ls -1 /usr/share/etherpad-lite/node_modules | grep -q ep_email_notifications || (cd /usr/share/etherpad-lite && sudo -u etherpad-lite npm install ep_email_notifications)
	# ep_page_view
	ls -1 /usr/share/etherpad-lite/node_modules | grep -q ep_page_view || (cd /usr/share/etherpad-lite && sudo -u etherpad-lite npm install ep_page_view)
	touch $@

etherpad-service.i : etherpad-config.i etherpad-init.i etherpad-sqlite3.i etherpad-plugins.i
	service etherpad-lite restart
	touch $@

etherpad.i : etherpad-pkg.i etherpad-config.i etherpad-sqlite3.i etherpad-plugins.i etherpad-user.i etherpad-init.i etherpad-service.i
	@echo "\n----- [info] etherpad installed\n"
	touch $@
