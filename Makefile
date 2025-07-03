SHELL         := /usr/bin/env zsh
.SHELLFLAGS   += -u -o pipefail
MAKEFLAGS     := --no-builtin-rules         \
                 --warn-undefined-variables \
                 --no-print-directory


repoDirName   !=  <<<$${PWD:t1}
backupDir     :=  ../.backup/$(repoDirName)
.DEFAULT_GOAL :=  all


.PHONY:\
all
all:
	@echo '(no "all" target yet)'


# ------------------------------------------------------------- #
#                             backup                            #
# ------------------------------------------------------------- #

##
## BACKUP
##
##   make backup                            # -> $(backupDir)/<date>.tgz
##   make backup SUFFIX=<suf>               # -> $(backupDir)/<date>_<suf>.tgz
##   make backup backupDir=<backup-dir> ..  # -> <backup-dir>/<date>..
##

.PHONY:\
backup
backup: suffix       := $(if $(value SUFFIX),_$(SUFFIX),)
backup: archive_name := $(shell date "+%Y-%m-%d_%H.%M.%S")$(suffix).tgz
backup:
	@mkdir -p $(backupDir)
	gtar -c -z \
	  --file       $(backupDir)/$(archive_name) \
	  --directory  ..           \
	  --exclude    ".DS_Store"  \
	  --exclude-vcs-ignores     \
	  $(repoDirName)
	@echo '\ncreated archive:'
	@lsd -l --color always $(backupDir)/$(archive_name)
	@printf '(%d archived files)\n' \
	        "$$(gtar --list -f $(backupDir)/$(archive_name) | wc -l)"


# ------------------------------------------------------------- #
#                             readme                            #
# ------------------------------------------------------------- #

README.md: colr
	> $@ printf '%s\n' \
	  '# `colr`' \
	  '_colorize text on stdin, or run a util and colorize its output_' \
	  '```help'
	>>$@ { ./colr --help | fmt }
	>>$@ printf '%s\n' \
	  '```' \
	  ''
