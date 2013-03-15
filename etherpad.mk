etherpad-pkg.i : utils-pkg.i
	aptitude search "~i nodejs" | grep -q nodejs || $(scripts_dir)/setup-nodejs
	ls -1 /usr/local | grep -q etherpad-lite || git clone https://github.com/ether/etherpad-lite.git /usr/local/etherpad-lite
	touch $@

etherpad-user.i :
	-adduser --system --home /usr/local/etherpad-lite --no-create-home --disabled-password --disabled-login etherpad-lite
	touch $@

etherpad-config.i : etherpad-user.i utils.i
	mkdir /var/local/etherpad-lite
	chown etherpad-lite:etherpad-lite /var/local/etherpad-lite
	$(jinja_copy) $(files_dir)/usr/local/etherpad-lite/settings.json.jinja $(settings) /usr/local/etherpad-lite/settings.json
	# Add init script
	touch $@

etherpad.i : etherpad-pkg.i etherpad-config.i etherpad-user.i
	@echo "\n----- [info] etherpad installed\n"
	touch $@
