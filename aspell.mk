aspell-pkg.i :
	$(apt_install) aspell
	touch $@

aspell-language-pkgs.i : aspell-pkg.i
	$(apt_install) aspell-ar-large aspell-de aspell-en aspell-es aspell-fr aspell-it aspell-nl aspell-pt-br aspell-pt-pt
	touch $@

aspell.i : aspell-pkg.i aspell-language-pkgs.i
	@echo "\n----- [info] aspell installed\n"
	touch $@
