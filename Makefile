PHP_VERSIONS = 7.2 7.3 7.4 8.0

MAKEFILE := $(lastword $(MAKEFILE_LIST))

.PHONY: $(PHP_VERSIONS)

build: $(PHP_VERSIONS)

7.2 7.3:
	@LIBICU="https://github.com/unicode-org/icu/releases/download/release-64-2/icu4c-64_2-src.tgz" \
	PHP_VERSION="$(@)" \
	XDEBUG_VERSION="3.0.2" \
	$(MAKE) -f $(MAKEFILE) -s generate

7.4:
	@LIBICU="https://github.com/unicode-org/icu/releases/download/release-65-1/icu4c-65_1-src.tgz" \
	PHP_VERSION="$(@)" \
	XDEBUG_VERSION="3.0.2" \
	$(MAKE) -f $(MAKEFILE) -s generate

generate: generate-alpine generate-debian

generate-alpine:
	@echo Generating Dockerfile for fpm-$(PHP_VERSION)-alpine
	@echo : LIBICU=$(LIBICU)
	@echo : PHP_VERSION=$(PHP_VERSION)
	@echo : XDEBUG_VERSION=$(XDEBUG_VERSION)
ifeq ("$(wildcard fpm-$(PHP_VERSION)-alpine)", "")
	@mkdir fpm-$(PHP_VERSION)-alpine
endif
	cp scripts/* fpm-$(PHP_VERSION)-alpine/
	sed -r \
		-e 's!%%LIBICU%%!'$(LIBICU)'!' \
		-e 's!%%PHP_VERSION%%!'$(PHP_VERSION)'!' \
		-e 's!%%XDEBUG_VERSION%%!'$(XDEBUG_VERSION)'!' \
		Dockerfile-alpine.template \
		> fpm-$(PHP_VERSION)-alpine/Dockerfile
	@docker build --pull --tag myonlinestore/php:fpm-$(PHP_VERSION)-alpine fpm-$(PHP_VERSION)-alpine
	@echo Done.

generate-debian:
	@echo Generating Dockerfile for fpm-$(PHP_VERSION)
	@echo : LIBICU=$(LIBICU)
	@echo : PHP_VERSION=$(PHP_VERSION)
	@echo : XDEBUG_VERSION=$(XDEBUG_VERSION)
ifeq ("$(wildcard fpm-$(PHP_VERSION))", "")
	@mkdir fpm-$(PHP_VERSION)
endif
	cp scripts/* fpm-$(PHP_VERSION)/
	@sed -r \
		-e 's!%%LIBICU%%!'$(LIBICU)'!' \
		-e 's!%%PHP_VERSION%%!'$(PHP_VERSION)'!' \
		-e 's!%%XDEBUG_VERSION%%!'$(XDEBUG_VERSION)'!' \
		Dockerfile-debian.template \
		> fpm-$(PHP_VERSION)/Dockerfile
	@docker build --pull --tag myonlinestore/php:fpm-$(PHP_VERSION) fpm-$(PHP_VERSION)
	@echo Done.
