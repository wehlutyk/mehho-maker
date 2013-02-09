files_dir := files/rootfs
scripts_dir := scripts
jinja_env := ENV-jinja2-cli.i
workon_jinja := source $(jinja_env)/bin/activate
jinjize := $(workon_jinja) && $(scripts_dir)/jinjize
settings := files/settings.yml
apt_install := apt-get -qy install
SHELL = /bin/bash
.SHELLFLAGS = -e

installs_mk := $(wildcard *.mk)
installs_i := $(patsubst %.mk,%.i,$(installs_mk))

all.i : $(installs_i)
	touch all.i

.PHONY : clean
clean :
	-rm -r *.i

include $(installs_mk)
