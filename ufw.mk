ufw-pkg.i :
	$(apt_install) ufw
	touch $@

ufw-default-deny.i : ufw-pkg.i
	ufw status verbose | grep -q "[D]efault: deny (incoming), allow (outgoing)" || ufw default deny
	touch $@

ufw-enable.i : ufw-pkg.i ufw-default-deny.i ufw-allow-ssh.i ufw-allow-http.i ufw-allow-https.i ufw-allow-smtp.i ufw-allow-smtp2525.i ufw-allow-imap.i ufw-allow-smtp.i ufw-allow-sieve.i
	ufw status verbose | grep -q "[S]tatus: active" || yes | ufw enable
	touch $@

ufw.i : ufw-pkg.i ufw-default-deny.i ufw-enable.i
	@echo "\n----- [info] ufw installed\n"
	touch $@
