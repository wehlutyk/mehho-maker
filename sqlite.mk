sqlite-pkg.i :
	$(apt_install) sqlite sqlite3
	touch $@

sqlite3-pkg.i :
	$(apt_install) sqlite3
	touch $@

sqlite.i : sqlite-pkg.i sqlite3-pkg.i
	@echo "\n----- [info] sqlite installed\n"
	touch $@
