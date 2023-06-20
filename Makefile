.PHONY: dotfiles

dotfiles:
	@echo Building dotfiles...
	@Rscript -e "rProject::ConfigFiles()"

#
# Note that the build process of the Docker and Apptainer containers
# are done via GitHub actions.
#
