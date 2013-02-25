prosody-pkg.i : sqlite.i sasl.i
	$(apt_install) prosody lua-zlib lua-event lua-dbi-sqlite3 lua-cyrussasl
	touch $@

prosody-config.i : prosody-pkg.i
	# Prosody settings
	$(jinja_copy) $(files_dir)/etc/prosody/prosody.cfg.lua.jinja $(settings) /etc/prosody/prosody.cfg.lua
	chmod 640 /etc/prosody/prosody.cfg.lua
	touch $@

ufw-allow-xmpp-c2s.i : ufw-pkg.i
	ufw status | grep -qE "5222 +ALLOW +Anywhere" || ufw allow 5222
	touch $@

ufw-allow-xmpp-s2s.i : ufw-pkg.i
	ufw status | grep -qE "5269 +ALLOW +Anywhere" || ufw allow 5269
	touch $@

prosody-service.i : prosody-config.i ufw-allow-xmpp-c2s.i ufw-allow-xmpp-s2s.i openssl.i sasl-service.i
	service prosody restart
	touch $@

prosody.i : prosody-pkg.i prosody-config.i ufw-allow-xmpp-c2s.i ufw-allow-xmpp-s2s.i prosody-service.i
	@echo "\n----- [info] prosody installed\n"
	touch $@
