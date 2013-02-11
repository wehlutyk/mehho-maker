openssl-pkg.i :
	$(apt_install) openssl
	touch $@

openssl-config.i : openssl-pkg.i utils.i
	$(jinja_copy) $(files_dir)/etc/ssl/openssl.cnf.jinja $(settings) /etc/ssl/openssl.cnf
	$(jinja_copy) $(files_dir)/etc/ssl/genkey.jinja $(settings) /etc/ssl/genkey
	chmod 755 /etc/ssl/genkey
	$(jinja_copy) $(files_dir)/etc/ssl/gencsr.jinja $(settings) /etc/ssl/gencsr
	chmod 755 /etc/ssl/gencsr
	$(jinja_copy) $(files_dir)/etc/ssl/genselfcerts.jinja $(settings) /etc/ssl/genselfcerts
	chmod 755 /etc/ssl/genselfcerts
	touch $@

openssl-genkey.i : openssl-config.i
	# Ignore errors here if the key already exists
	-cd /etc/ssl && ./genkey
	touch $@

openssl-genselfcerts.i : openssl-genkey.i
	# Ignore errors here if the certs already exist
	-cd /etc/ssl && ./genselfcerts
	touch $@

openssl.i : openssl-pkg.i openssl-config.i openssl-genkey.i openssl-genselfcerts.i
	@echo "\n----- [info] openssl installed\n"
	touch $@
