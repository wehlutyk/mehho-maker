sasl-pkg.i :
	$(apt_install) sasl2-bin
	touch $@

sasl-config.i : sasl-pkg.i
	sed -i 's/^START=no/START=yes/' /etc/default/saslauthd
	touch $@

sasl-service.i : sasl-config.i
	service saslauthd restart
	touch $@

sasl.i : sasl-pkg.i sasl-config.i sasl-service.i
	@echo "\n----- [info] sasl installed\n"
	touch $@
