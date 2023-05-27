.PHONY: build term clean

build:
	sudo -E bash apptainer.sh

term:
	@echo Building .bashrc and .vimrc...
	@(cd .setup/bash && make)
	@(cd .setup/vim && make)
	@echo Setting git...
	@(cd .setup/git && make)
	@echo Setting ssh keys...
	@(cd .setup/ssh && make)

clean:
	@rm -rf *.sif
	@docker system prune -a
	@docker rmi $(docker images -a -q)
	@docker stop $(docker ps -a -q)
	@docker rm $(docker ps -a -q)
