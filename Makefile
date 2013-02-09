# Base directories
files_dir := files/rootfs
scripts_dir := scripts

# Jinja stuff
jinja_env := ENV-jinja2-cli.i
workon_jinja := source $(jinja_env)/bin/activate
jinjize := $(workon_jinja) && $(scripts_dir)/jinjize
jinja_run := $(workon_jinja) && $(scripts_dir)/jinja_run
jinja_copy := $(workon_jinja) && $(scripts_dir)/jinja_copy

# Shortcuts
apt_install := apt-get -qy install

# System settings
settings_jinja := files/settings.yml.jinja
settings := settings.yml.i

# Make settings
SHELL = /bin/bash
.SHELLFLAGS = -e

# We take all .mk files
installs_mk := $(wildcard *.mk)

# Those files generate .i files
installs_i := $(patsubst %.mk,%.i,$(installs_mk))

all.i : $(installs_i)
	touch all.i

.PHONY : clean
clean :
	-rm -r *.i

include $(installs_mk)
