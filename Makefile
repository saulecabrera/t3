.PHONY: test up down server iex

DOCKER := docker
DOCKERC := docker-compose
ECHO := /usr/bin/env echo

server:
	@$(ECHO) "Starting the server"
	@$(ECHO) "-------------------"
	@$(DOCKERC) up 

up:
	@$(ECHO) "Building the container"
	@$(ECHO) "----------------------" 
	@$(DOCKERC) build

down:
	@$(ECHO) "Stopping the container"
	@$(ECHO) "----------------------" 
	@$(DOCKERC) stop

test:
	@$(ECHO) "Starting tests"
	@$(ECHO) "---------------" 
	@$(DOCKERC) exec t3 mix test

iex:
	@$(ECHO) "Starting iex"
	@$(ECHO) "---------------" 
	@$(DOCKERC) exec t3 iex -S mix

