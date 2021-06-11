#!/usr/bin/make  ### targets.make - basic targets for makefiles
#
# This file is meant to be included by Tools/Makefile, and defines a
# generally-useful collection of targets.
#

### deployment ###

.PHONY: pre-deploy deploy-this deploy-r

# pre-deploy does any necessary preparation for deployment.
#	deploy depends on it after all.  A site's config.make may add a
#	dependency on deploy-r to get a recursive deployment.
pre-deploy::
	@echo deploying $(MYNAME)...

ifneq ($(GIT_REPO),)

# deploy-this does a deployment (using git) but nothing else.
#	DEPLOY_OPTS can be used to add, e.g., --allow-empty
#	Succeeds even if the push is not done: there may be additional
#	dependencies, such as rsync deployments.
deploy-this:: | $(GIT_REPO)
	-@if git remote|grep -q origin && git branch|grep -q '* master'; then	\
	   git commit $(DEPLOY_OPTS) -a -m "Deployed $(COMMIT_MSG)";		\
	   if git diff --quiet origin/master; then				\
		echo "git deployment not needed: up to date";			\
	   else									\
	   	git push --tags origin master | tee /dev/null;			\
	   fi									\
	elif git remote|grep -q origin; then					\
	   echo "not on branch master; not deploying.";				\
	fi

# deploy-tag should be done explicitly in most cases.
deploy-tag::
	git tag -a -m "Deployed $(COMMIT_MSG)" deployed/$(TIMESTAMP);
	git push --tags | tee /dev/null

endif

# deploy-r does pre-deploy and deploy-this in subdirectories.
#	It uses pre-deploy and deploy-this to avoid recursively doing
#	make all, which the top-level make deploy has already done, but
#	blythely assumes that a deploy target implies their existence.
deploy-r::
	@echo deploying makeable subdirectories
	@for d in $(SUBDIRS); do grep -qs deploy: $$d/Makefile &&	\
	     (cd $$d; $(MAKE) pre-deploy deploy-this) done

# deploy-rgit pushes subdirectories with .git and no deploy: target
#	It uses Makefile in the parent directory to do push-this.
#
deploy-rgit::
	@echo deploying git-only subdirectories
	@for d in $(GITDIRS); do grep -qs deploy: $$d/Makefile ||	\
	     (cd $$d; $(MAKE) -f ../Makefile push-this) done

# push is essentially the same as (git-only) deploy except that
#	* it doesn't verify that master is the current branch.
#	* it recurses automatically into git-controled subdirectories,
#	* ...but doesn't require a makefile with a push target there.
#
.PHONY: push push-this push-r commit
push:	all push-this push-r

commit:: | $(GIT_REPO)
	-if $(commit_msg_overridden); then :; else msg_prefix="on "; fi;	\
	 git commit -a -m "$${msg_prefix}$(COMMIT_MSG)" $(COMMIT_OPTS)

push-this:: | $(GIT_REPO)
	-@if $(commit_msg_overridden); then :; else msg_pfx="Push from "; fi;	\
	  if git remote|grep -q origin; then					\
	   [ -z "`git status --porcelain`" ]					\
	     || git commit -a -m "$${msg_pfx}$(COMMIT_MSG)" $(COMMIT_OPTS);	\
	   git push | tee /dev/null;						\
	fi

# push-r recursively pushes in GITDIRS
#	It uses "make push-this push-r" if possible, otherwise git push.
#	Note the use of plain make rather than $(MAKE); this is necessary
#	to prevent "make -n" from doing an actual push in the subdirs.
#
push-r::
	@for d in $(GITDIRS); do 					\
	    if [ -d $$d/.git/refs/remotes/origin ]; then (cd $$d;	\
		 echo pushing in $$d;					\
		 if grep -qs deploy: Makefile;				\
		    then make push-this push-r;				\
		 fi)							\
	    fi; 							\
	done

# push-R recursively pushes every git repo it can find.
push-R::
	@for d in $(GITDIRS); do 					\
	    if [ -d $$d/.git/refs/remotes/origin ]; then (cd $$d;	\
		 echo pushing in $$d;					\
		 if grep -qs deploy: Makefile;				\
		    then make push-this push-r;				\
		    else git push|tee /dev/null; fi)			\
	    fi; 							\
	done

# pull does pull --rebase
#	It's simpler than push because it doesn't do a build first.
#	It's still split up, so that you can run the pieces separately
#
.PHONY: pull pull-this pull-r
pull: pull-this pull-r

pull-this::
	@if [ -d .git/refs/remotes/origin ]; then 		\
	    git pull --rebase | tee /dev/null; 			\
	fi

pull-r:: 
	@for d in $(GITDIRS); do (cd $$d; 			\
	    echo pulling into $$d;				\
	    if grep -qs deploy: Makefile;			\
		then make pull;					\
		else git pull --rebase; fi)			\
	done


### rsync deployment ###

.PHONY: put rsync rsync-this rsync-r
put:	# put used to be the main deployment target; it is now deprecated.
	@echo deprecated:  use deploy, push, or rsync; false

# rsync does a full recursive rsync with --delete and --cvs-exclude
#	.git and {Master,Premaster,Tracks} are also excluded
rsync:
	rsync -aC -z -v $(EXCLUDES) --delete $(RSYNC_FLAGS) 	\
	      ./ $(HOST):$(DOTDOT)/$(MYNAME)

# rsync-this syncs just the current directory, with no deletion.
rsync-this:
	rsync -lptC -z -v $(EXCLUDES) $(RSYNC_FLAGS) 		\
	      ./ $(HOST):$(DOTDOT)/$(MYNAME)

# rsync-r syncs recursively only the (files and) subdirectories in
#	RSYNC_THESE, which should be defined in config.make
ifdef RSYNC_THESE
rsync-r:
	@echo recursive rsync of $(RSYNC_THESE):
	rsync -aC -z -v $(EXCLUDES) $(RSYNC_FLAGS) 		\
	      $(RSYNC_THESE) $(HOST):$(DOTDOT)/$(MYNAME)
else
rsync-r:
	@echo rsync-r is a no-op unless RSYNC_THESE is defined.
endif

### reporting ###

.PHONY: sloc-count status
sloc-count: sloc.log
	cat sloc.log

sloc.log:: 
	sloccount --addlang makefile . > $@

status:
	echo git status for $(MYNAME) and subdirs
	@$(TOOLDIR)/scripts/git-status-all

### Cleanup ###

.PHONY: texclean clean

texclean::
	-rm -f *.aux *.log *.toc *.dvi

clean::
	-rm -f *.CKP *.ln *.BAK *.bak *.o core errs  *~ *.a 	\
		.emacs_* tags TAGS MakeOut *.odf *_ins.h 	\
		*.aux *.log *.toc *.dvi
### Setup ###

.PHONY: deployable remote-repo

deployable: .git .git/refs/remotes/origin/master
	$(TOOLDIR)/scripts/init-deployment

remote-repo:  .git/refs/remotes/origin/master

.git/refs/remotes/origin/master:
	$(TOOLDIR)/scripts/init-remote-repo

## Template expansions:

to.do:
	echo "$$TO_DO" > $@

### Fixup ###

# makeable - link a Makefile from Tools.
#	This will also fix a broken Makefile link
.PHONY: makeable
makeable: 
	@if [ ! -L Makefile -o ! -e Makefile ]; then 		\
	   if [ -f Makefile ]; then git rm -f Makefile; fi; 	\
	   echo linking to $(TOOLREL)/Makefile			\
	   ln -s $(TOOLREL)/Makefile .; 			\
	   git add Makefile; 					\
	   git commit -m "Makefile linked from MakeStuff";	\
	fi

### site-wide targets and depends:

ifdef SITEDIR
  -include $(SITEDIR)/targets.make $(SITEDIR)/depends.make
endif

###### end of targets.make ######
