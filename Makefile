# Add utility functions and scripts to the container
include configs/makefile/*.mk

.PHONY: all up down prepare install exec info phpcs

# Read project name from .env file
$(shell cp -n \.env.default \.env)
include .env

# Get local values only once.
LOCAL_UID := $(shell id -u)
LOCAL_GID := $(shell id -g)

# Evaluate recursively.
CUID ?= $(LOCAL_UID)
CGID ?= $(LOCAL_GID)

# Prepare network name https://github.com/docker/compose/issues/2923
COMPOSE_NET_NAME := $(shell echo $(COMPOSE_PROJECT_NAME) | tr '[:upper:]' '[:lower:]'| sed -E 's/[^a-z0-9]+//g')_front

jekyll = docker-compose exec -T --user $(CUID):$(CGID) jekyll time ${1}
jekyll-0 = docker-compose exec -T jekyll time ${1}

## Full site install from the scratch
all: | include prepare lib info

include:
ifeq ($(strip $(COMPOSE_PROJECT_NAME)),projectname)
#todo: ask user to make a project name and mv folders.
$(error Project name can not be default, please edit ".env" and set COMPOSE_PROJECT_NAME variable.)
endif

prepare:
	make -s down
	make -s up

## install node_modules for project by Yarn
lib:
	make -s down
	make -s up
	# TODO: implement nodejs container + yarn
	@echo "Building libraries dependencies tasks..."
	$(call jekyll, /bin/sh -c "cd /srv/jekyll/src/${COMPOSE_PROJECT}/lib && yarn install")

## Project's containers information
info:
ifeq ($(shell docker inspect --format="{{ .State.Running }}" $(COMPOSE_PROJECT_NAME)_jekyll 2> /dev/null),true)
	@echo Project http://$(shell docker inspect --format='{{.NetworkSettings.Networks.$(COMPOSE_NET_NAME).IPAddress}}' $(COMPOSE_PROJECT_NAME)_jekyll)
endif

chown:
# Use this goal to set permissions in docker container
	$(call jekyll-0, /bin/sh -c "chown $(CUID):$(CGID) /srv/jekyll/html -R")
	$(call jekyll-0, /bin/sh -c "chown $(CUID):$(CGID) /srv/jekyll/src -R")

## Run shell in PHP container as CUID:CGID user
exec:
	docker-compose exec --user $(CUID):$(CGID) jekyll ash

## Run shel in PHP container as root
exec0:
	docker-compose exec jekyll ash

up: net
	@echo "Updating containers..."
	docker-compose pull --parallel
	@echo "Build and run containers..."
	docker-compose up -d --remove-orphans

down:
	@echo "Removing network & containers for $(COMPOSE_PROJECT_NAME)"
	@docker-compose down -v --remove-orphans

net:
ifeq ($(shell docker network ls -q -f Name=$(COMPOSE_NET_NAME)),)
	docker network create $(COMPOSE_NET_NAME)
endif
ifeq ($(shell grep -c -F 'IPRANGE=' .env), 0)
#	@echo Define IP range $(net-range)
	@printf "\nIPRANGE=%s\n" $(shell docker network inspect $(COMPOSE_NET_NAME) --format '{{(index .IPAM.Config 0).Subnet}}') >> .env
else
	@if [ '$(IPRANGE)' != '$(shell docker network inspect $(COMPOSE_NET_NAME) --format '{{(index .IPAM.Config 0).Subnet}}')' ]; then echo "Replace IP range $(IPRANGE)"; sed -i ".bak" "s#IPRANGE=.*#IPRANGE=$(shell docker network inspect $(COMPOSE_NET_NAME) --format '{{(index .IPAM.Config 0).Subnet}}')#" .env; fi;
	rm -f .env.bak
endif
#	grep -q -F 'IPRANGE=' .env || printf "\nIPRANGE=$(shell docker network inspect $(COMPOSE_NET_NAME) --format '{{(index .IPAM.Config 0).Subnet}}')" >> .env
