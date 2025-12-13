
info:
	@echo "This is Makefile is used to manage submodules of the git repository."
	@echo "- Using the following targets: "
	@echo "    fetch_all         : fetch all remote changes for all submodules"
	@echo "    pull_all          : pull all remote changes for all submodules"
	@echo "    checkout_b_dev    : checkout 'dev' branch for all submodules"
	@echo "    checkout_b_main   : checkout 'main' branch for all submodules"
	@echo "    update_dev_ref    : commit the 'dev' changes for all submodules under (portfolio) repo"
	@echo "    update_main_ref: commit the 'main' changes for all submodules under (portfolio) repo"
	@echo "    push_dev          : push changes of 'dev' branch to remote"
	@echo "    push_main         : push changes of 'main' branch to remote"
	@echo "    subm_status       : ..."
	@echo "    subm_update_ref   : ..."
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

# log files for status of the dev/main branches
STATUS_DEV_LOG  ?= $(DIR_LOG)/status_dev_br.log
STATUS_MAIN_LOG ?= $(DIR_LOG)/status_main_br.log

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


# Submodule path (TO-DO)
SUBM_PATH   ?= ./ 
SUBM_BRANCH ?= main



#############################################
################ TARGETS  ###################
# Create temporarely gitlogs directory
create_log_dir:
	@echo "INFO: Create $(DIR_LOG) directory for saving log of launched git commands."
	mkdir -p $(DIR_LOG)

# Status of dev/main branch recursively
status_dev: create_log_dir checkout_b_dev
	@echo "============================================================="
	@echo "INFO: Status of 'dev' branch... " | tee $(STATUS_DEV_LOG)
	git submodule foreach --recursive git status | tee $(STATUS_DEV_LOG)
	@echo "============================================================="

status_main: create_log_dir checkout_b_main
	@echo "============================================================="
	@echo "INFO: Status of 'main' branch... " | tee $(STATUS_MAIN_LOG)
	git submodule foreach --recursive git status | tee $(STATUS_MAIN_LOG)
	@echo "============================================================="


# Fetch all branches of the submodules from remote
fetch_all: 
	@echo "============================================================="
	@echo "INFO: Fetching everything from remote "  | tee $(FETCH_LOG)
	git submodule foreach --recursive git fetch --all | tee $(FETCH_LOG)
	@echo "============================================================="

# Pull all branches of the submodules
pull_all: 
	@echo "============================================================="
	@echo "INFO: Pulling everything from remote "  | tee $(PULL_LOG)
	git submodule foreach --recursive git pull --all  | tee $(PULL_LOG)
	@echo "============================================================="

# Checkout dev/main branches for all submodules
checkout_b_dev: 
	@echo "============================================================="
	@echo "INFO: Checkout 'dev' branch for all submodules "  | tee $(CK_DEV_LOG)
	git checkout dev
	git submodule foreach --recursive git checkout dev  | tee $(CK_DEV_LOG)
	@echo "============================================================="

checkout_b_main: 
	@echo "============================================================="
	@echo "INFO: Checkout 'main' branch for all submodules"  | tee $(CK_MAIN_LOG)
	git checkout main
	git submodule foreach --recursive git checkout main  | tee $(CK_MAIN_LOG)
	@echo "============================================================="


# Commit the staged changes of dev branch of submodules
update_dev_ref: checkout_b_dev
	@echo "============================================================="
	@echo "INFO: Update parent repo (portfolio) commit on dev branch"  | tee $(CMT_DEV_LOG)
	git commit -m "update submodule commit (dev branch)" | tee $(CMT_DEV_LOG)
	@echo "============================================================="


update_main_ref: checkout_b_main
	@echo "============================================================="
	@echo "INFO: Update parent repo (portfolio) commit on main branch"  | tee $(CMT_MAIN_LOG)
	git commit -m "update submodule commit (main branch)" | tee $(CMT_MAIN_LOG)
	@echo "============================================================="

# Push to remote dev/main 
push_dev: update_dev_ref
	@echo "============================================================="
	@echo "INFO: Pushing change on parent repo (portfolio) to dev"  | tee $(PUSH_DEV_LOG)
	git push origin dev | tee $(PUSH_DEV_LOG)
	@echo "============================================================="

push_main: update_main_ref
	@echo "============================================================="
	@echo "INFO: Pushing change on parent repo (portfolio) to main"  | tee $(PUSH_MAIN_LOG)	
	git push origin main | tee $(PUSH_MAIN_LOG)
	@echo "============================================================="

# TO-DO : Manage specific submodule
# Tcl scripts should be used to update submodules reference upward 
subm_status:
	@echo "============================================================="
	@echo "INFO: Current status of the submodule '$(SUBM_PATH)' on branch: $(SUBM_BRANCH) "
	git -C $(SUBM_PATH) checkout $(SUBM_BRANCH)
	git -C $(SUBM_PATH) status
	@echo "============================================================="

subm_update_ref: subm_status
	@echo "============================================================="
	@echo "INFO: Pulling everything from remote "
	git -C $(SUBM_PATH) submodule update --remote
	git commit -m "update submodule commit $(SUBM_BRANCH) branch"
# 	git push origin $(SUBM_BRANCH)
	@echo "============================================================="
