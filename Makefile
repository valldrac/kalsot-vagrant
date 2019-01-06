device = gl-ar150
openwrt_cfg = $(device).cfg

sources = $(shell find onionwall)

make_args = $(if $(V),V=$(V),-j3 -Otarget)

ifdef debug
make_args += CONFIG_DEBUG=y CONFIG_GDB=y
endif

.PHONY: all firmware menuconfig clean dirclean distclean

.SUFFIXES:

all: firmware

firmware: .rsynced .feeds
	vagrant ssh -c "cd /onionwall \
	  && cp $(openwrt_cfg) .config \
	  && make $(make_args) defconfig world \
	  && cp -R bin /firmware/"

.rsynced: $(sources)
	vagrant rsync
	touch $@

.feeds: onionwall/feeds.conf | .rsynced
	vagrant ssh -c "cd /onionwall \
	  && ./scripts/feeds update -a \
	  && ./scripts/feeds install -a"
	touch $@

menuconfig: .rsynced .feeds
	vagrant ssh -c "cd /onionwall \
	  && cp $(openwrt_cfg) .config \
	  && make menuconfig \
	  && ./scripts/diffconfig.sh > /firmware/diffconfig"
	mv -v firmware/diffconfig onionwall/$(openwrt_cfg)

clean:
	rm -rf firmware/bin firmware/diffconfig .rsynced .feeds

dirclean: clean
	vagrant ssh -c "make -C /onionwall clean"

distclean: clean
	vagrant ssh -c "find /onionwall -mindepth 1 -delete"
