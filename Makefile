install_dir ?= /web-services/order-form
shards_opts := --verbose --stats --progress

all:	install

bin/order-form:
	shards build $(shards_opts) --release --production 

dev-build:
	shards build $(shards_opts)

install:	$(install_dir)	$(install_dir)/bin/order-form	bin/order-form	$(install_dir)/client	$(install_dir)/config.yml	/etc/systemd/system/Order-Form.service
	sudo systemctl daemon-reload
	sudo systemctl enable --now Order-Form
# cp index-actual.html $(install_dir)/client/index.html

uninstall:
	-sudo systemctl disable --now Order-Form
	-sudo rm /etc/systemd/system/Order-Form.service
	-sudo rm -r $(install_dir)/client
	-sudo rm -r $(install_dir)/bin
	-sudo rm -r $(install_dir)/config.yml

wipe:	uninstall
# WIPES THE DATABASE
	@echo "wipes the database! continue? [y/N]" && read confirm && test $${ans:-N} = y
	sudo rm -r $(install_dir)

$(install_dir):
	sudo mkdir $@
	sudo chown scott:scott $@

$(install_dir)/bin:	$(install_dir)
	-mkdir $@

$(install_dir)/bin/order-form:	$(install_dir)/bin	bin/order-form
	cp bin/order-form	$@

/etc/systemd/system/Order-Form.service:
	sudo cp Order-Form.service $@

$(install_dir)/client:	$(install_dir)
	cd order-form-client && yarn build
	rsync -a --partial order-form-client/dist/ $@

$(install_dir)/config.yml:	$(install_dir)
	cp production-config.yml $@