DOCKER_IMAGE := ghcr.io/octarect/nvim

all:

.PHONY: image
image:
	docker image build -t $(DOCKER_IMAGE) .

.PHONY: run
run: image
	docker container run --rm -it \
		-v $(PWD):/root/.config/nvim:ro \
		-w /root/.config/nvim \
		$(DOCKER_IMAGE)

.PHONY: clean
clean:
	docker image rm -f $(DOCKER_IMAGE)

.PHONY: fmt
fmt:
	stylua .

.PHONY: lint
lint:
	luacheck .
