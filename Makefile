DOCKER_IMAGE    := ghcr.io/octarect/nvim
XDG_CONFIG_HOME ?= $(HOME)/.config

all:

$(XDG_CONFIG_HOME)/nvim:
	ln -s $(PWD) $(XDG_CONFIG_HOME)/nvim

.PHONY: image
image:
	docker image build -t $(DOCKER_IMAGE) .

.PHONY: run
run: image
	docker container run --rm -it \
		-v $(PWD):/root/.config/nvim:ro \
		-w /root/.config/nvim \
		-e NVIM_DISABLE_COPILOT=true \
		$(DOCKER_IMAGE)

.PHONY: install
install: $(XDG_CONFIG_HOME)/nvim

.PHONY: uninstall
uninstall:
	rm $(XDG_CONFIG_HOME)/nvim

.PHONY: clean
clean:
	docker image rm -f $(DOCKER_IMAGE)

.PHONY: fmt
fmt:
	stylua .

.PHONY: lint
lint:
	luacheck .
