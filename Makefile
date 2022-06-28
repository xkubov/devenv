.PHONY: build \
	help

# Show this help
help:
	@echo "Use \`make <target>\`, where <target> is one of"
	@awk '/^#/{c=substr($$0,3);next}c&&/^[[:alpha:]][[:alnum:]_-]+:/{print substr($$1,1,index($$1,":")),c}1{c=0}' $(MAKEFILE_LIST) | column -s: -t | sed 's/^/  /'

# Build devenv docker image.
build:
	docker build -t devenv .

# Run devenv with specified directory as base.
run:
	@test ! -z $(BASE) || (echo "make run BASE=PATH" && exit 1)
	@docker run -v $(realpath $(BASE)):/devel --net=host -it --rm --entrypoint /bin/fish -t devenv
