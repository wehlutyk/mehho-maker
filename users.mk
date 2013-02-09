# Generic groups
group-admin.i :
	getent group | grep -q "^admin:" || addgroup --gid 300 admin
	touch $@

group-sshlogin.i :
	getent group | grep -q "^sshlogin:" || addgroup --gid 301 sshlogin
	touch $@

group-sshnopwd.i :
	getent group | grep -q "^sshnopwd:" || addgroup --gid 302 sshnopwd
	touch $@

group-user.i :
	getent group | grep -q "^user:" || addgroup --gid 400 user
	touch $@

group-data.i :
	getent group | grep -q "^data:" || addgroup --gid 401 data
	touch $@

disable-root.i : setup-users.i sudo.i
	cat /etc/shadow | grep "^root:!" || usermod -L root
	touch $@

# Utilities for setting up users
skel-folder.i : utils.i
	rsync -rq --delete $(files_dir)/etc/skel /etc/
	touch $@

adduser-full.i : utils.i group-user.i group-data.i
	$(workon_jinja) && jinja2 --format=yaml $(files_dir)/usr/local/bin/adduser-full.jinja $(settings) > /usr/local/bin/adduser-full
	chmod 750 /usr/local/bin/adduser-full
	touch $@

deluser-full.i : utils.i group-user.i group-data.i
	$(workon_jinja) && jinja2 --format=yaml $(files_dir)/usr/local/bin/deluser-full.jinja $(settings) > /usr/local/bin/deluser-full
	chmod 750 /usr/local/bin/deluser-full
	touch $@

setup-users.i : group-admin.i group-user.i group-data.i skel-folder.i
	$(jinjize) $(scripts_dir)/setup-users.jinja $(settings)
	touch $@

users.i : group-admin.i group-sshlogin.i group-sshnopwd.i group-user.i group-data.i disable-root.i skel-folder.i adduser-full.i deluser-full.i setup-users.i
	@echo "\n----- [info] users installed\n"
	touch $@
