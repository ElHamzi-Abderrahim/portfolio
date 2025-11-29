
info:
	@echo "This is Makefile is used to manage submodules of the git repository."
	@echo "- Using the following targets: "
	@echo "    fetch_all         : fetch all remote changes for all submodules"
	@echo "    pull_all          : pull all remote changes for all submodules"
	@echo "    checkout_b_dev    : checkout 'dev' branch for all submodules"
	@echo "    checkout_b_main   : checkout 'main' branch for all submodules"
	@echo "    update_dev_commit : commit the 'dev' changes for all submodules"
	@echo "    update_main_commit: commit the 'main' changes for all submodules"
	@echo "    push_dev          : push changes of 'dev' branch to remote"
	@echo "    push_main         : push changes of 'main' branch to remote"
	@echo ""
	@echo "- Env. Variables that can be specified:"
	@echo "  + For specific args for git commands:"
	@echo "      COMMIT_MESSAGE: (TO-DO) to personalize the commit message for the current staged changes"
	@echo "  + For loging results of git commands:"
	@echo "      DIR_LOG       : output dir for log files (default: ./gitlogs)"
	@echo "      FETCH_LOG     : output log file for fetching all submodules branches (default: DIR_LOG/pull.log )"
	@echo "      PULL_LOG      : output log file for pulling all submodules branches  (default: DIR_LOG/fetch.log)"
	@echo "      CK_DEV_LOG    : output log file for checking out 'dev' branch        (default: DIR_LOG/checkout_dev.log)"
	@echo "      CK_MAIN_LOG   : output log file for checking out 'main' branch       (default: DIR_LOG/checkout_main.log)"
	@echo "      CMT_DEV_LOG   : output log file for commiting the changes for 'dev'  (default: DIR_LOG/commit_dev.log)"
	@echo "      CMT_MAIN_LOG  : output log file for commiting the changes for 'main' (default: DIR_LOG/commit_main.log)"
	@echo "      PUSH_DEV_LOG  : output log file for pushing to 'dev'                 (default: DIR_LOG/push_dev.log)"
	@echo "      PUSH_MAIN_LOG : output log file for pushing to 'main'                (default: DIR_LOG/push_main.log)"



#############################################
############# TARGET ARGUMENTS ##############
# dir for log files: 
DIR_LOG   ?= ./gitlogs

# log files for fetch/pull of the all the branches
FETCH_LOG ?= $(DIR_LOG)/fetch.log 
PULL_LOG  ?= $(DIR_LOG)/pull.log 

# log files for checkout of dev/main branch
CK_DEV_LOG  ?= $(DIR_LOG)/checkout_dev.log 
CK_MAIN_LOG ?= $(DIR_LOG)/checkout_main.log 

# log files for committing of dev/main branch
CMT_DEV_LOG  ?= $(DIR_LOG)/commit_dev.log 
CMT_MAIN_LOG ?= $(DIR_LOG)/commit_main.log 

# log files for pushing of dev/main branch
PUSH_DEV_LOG  ?= $(DIR_LOG)/push_dev.log 
PUSH_MAIN_LOG ?= $(DIR_LOG)/push_main.log 

# Commit Message (TO-DO)
COMMIT_MESSAGE ?= "Default_message_for_the_commit"




#############################################
################ TARGETS  ###################
# Fetch all branches of the submodules from remote
fetch_all: 
	git submodule foreach --recursive git fetch --all | tee $(FETCH_LOG)

# Pull all branches of the submodules
pull_all: 
	git submodule foreach --recursive git pull --all  | tee $(PULL_LOG)


# Checkout dev/main branches for all submodules
checkout_b_dev: 
	git submodule foreach --recursive git checkout dev  | tee $(CK_DEV_LOG)

checkout_b_main: 
	git submodule foreach --recursive git checkout main  | tee $(CK_MAIN_LOG)


# Commit the staged changes of dev branch of submodules
update_dev_commit: checkout_b_dev
	git commit -m "update submodule commit (dev branch)" | tee $(CMT_DEV_LOG)

update_main_commit: checkout_b_main
	git commit -m "update submodule commit (main branch)" | tee $(CMT_MAIN_LOG)


# Push to remote dev/main 
push_dev: update_dev_commit
	git push origin dev | tee $(PUSH_DEV_LOG)

push_main: update_main_commit
	git push origin main | tee $(PUSH_MAIN_LOG)