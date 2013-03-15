etherpad-pkg.i : utils-pkg.i
	aptitude search "~i nodejs" | grep -q nodejs || $(scripts_dir)/setup-nodejs
	ls -1 /usr/local | grep -q etherpad-lite || git clone https://github.com/ether/etherpad-lite.git /usr/local/etherpad-lite
	touch $@

etherpad-user.i :
	getent passwd | grep -q "^etherpad-lite:" || adduser --system --group --home /usr/local/etherpad-lite --no-create-home --disabled-password --disabled-login etherpad-lite
	touch $@

etherpad-config.i : etherpad-user.i utils.i
	mkdir -p /var/local/etherpad-lite
	chown -R etherpad-lite:etherpad-lite /var/local/etherpad-lite
	$(jinja_copy) $(files_dir)/usr/local/etherpad-lite/settings.json.jinja $(settings) /usr/local/etherpad-lite/settings.json
	chown -R etherpad-lite:etherpad-lite /usr/local/etherpad-lite
	# Add init script and nginx config
	touch $@

etherpad.i : etherpad-pkg.i etherpad-config.i etherpad-user.i
	@echo "\n----- [info] etherpad installed\n"
	touch $@
