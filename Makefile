base_dir := $(CURDIR)
files_dir := $(base_dir)/files
apt_install := apt-get -qy install

installs_mk := $(wildcard *.mk)
installs_i := $(patsubst %.mk,%.i,$(installs_mk))

all.i : $(installs_i)
	touch all.i

.PHONY : clean
clean :
	-rm *.i

include $(installs_mk)
