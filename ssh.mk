openssh-client-pkg.i :
	$(apt_install) openssh-client
	touch $@

openssh-server-pkg.i :
	$(apt_install) openssh-server
	touch $@

ssh-service.i : sshd-config.i
	service ssh restart
	touch $@

sshd-config.i : openssh-server-pkg.i group-sshlogin.i group-sshnopwd.i users.i
	cp $(files_dir)/etc/ssh/sshd_config /etc/ssh/sshd_config
	touch $@

ufw-allow-ssh.i : ufw-pkg.i
	ufw status | grep -qE "22 +ALLOW +Anywhere" || ufw allow 22
	touch $@

ssh.i : openssh-client-pkg.i openssh-server-pkg.i ssh-service.i sshd-config.i ufw-allow-ssh.i
	@echo "\n----- [info] ssh installed\n"
	touch $@
