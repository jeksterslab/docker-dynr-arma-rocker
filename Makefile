.PHONY: build term clean

build:
	@if (( $EUID != 0 )); then sudo -E bash apptainer.sh; else bash apptainer.sh; fi

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
