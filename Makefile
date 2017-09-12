
# include env_make

NS       = bodsch
VERSION ?= latest

REPO     = docker-jmx4perl
NAME     = jmx4perl
INSTANCE = default

.PHONY: build push shell run start stop rm release


build:
	docker build \
		--rm \
		--tag $(NS)/$(REPO):$(VERSION) .

clean:
	docker rmi \
		--force \
		$(NS)/$(REPO):$(VERSION)

history:
	docker history \
		$(NS)/$(REPO):$(VERSION)

push:
	docker push \
		$(NS)/$(REPO):$(VERSION)

shell:
	docker run \
		--rm \
		--name $(NAME)-$(INSTANCE) \
		--interactive \
		--tty \
		$(PORTS) \
		$(VOLUMES) \
		$(ENV) \
		$(NS)/$(REPO):$(VERSION) \
		/bin/sh

run:
	docker run \
		--rm \
		--name $(NAME)-$(INSTANCE) \
		$(PORTS) \
		$(VOLUMES) \
		$(ENV) \
		$(NS)/$(REPO):$(VERSION)

j4psh:
	docker run \
		--rm \
		--name $(NAME)-$(INSTANCE) \
		--interactive \
		--tty \
		--link jolokia-default:jolokia \
		$(NS)/$(REPO):$(VERSION) \
		j4psh http://jolokia:8080/jolokia

jmx4perl:
	docker run \
		--rm \
		--name $(NAME)-$(INSTANCE) \
		--interactive \
		--tty \
		--link jolokia-default:jolokia \
		$(NS)/$(REPO):$(VERSION) \
		jmx4perl --product tomcat http://jolokia:8080/jolokia

check_jmx4perl:
	docker run \
		--rm \
		--name $(NAME)-$(INSTANCE) \
		--interactive \
		--tty \
		--link jolokia-default:jolokia \
		$(NS)/$(REPO):$(VERSION) \
		check_jmx4perl --url http://jolokia:8080/jolokia \
		--mbean java.lang:type=Memory    \
		--attribute HeapMemoryUsage      \
		--path used                      \
		--base java.lang:type=Memory/HeapMemoryUsage/max \
		--warning 80                     \
		--critical 90

exec:
	docker exec \
		--interactive \
		--tty \
		$(NAME)-$(INSTANCE) \
		/bin/sh

start:
	docker run \
		--detach \
		--name $(NAME)-$(INSTANCE) \
		$(PORTS) \
		$(VOLUMES) \
		$(ENV) \
		$(NS)/$(REPO):$(VERSION)

stop:
	docker stop \
		$(NAME)-$(INSTANCE)

rm:
	docker rm \
		$(NAME)-$(INSTANCE)

release: build
	make push -e VERSION=$(VERSION)

default: build
