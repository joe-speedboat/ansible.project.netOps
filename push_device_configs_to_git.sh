#!/bin/bash
##########################################################################################################
# Copyright (c) Chris Ruettimann <chris@bitbull.ch>

# This software is licensed to you under the GNU General Public License.
# There is NO WARRANTY for this software, express or
# implied, including the implied warranties of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
# along with this software; if not, see
# http://www.gnu.org/licenses/gpl.txt
#
# DESC: search directory for file pattern, eg: *.cfg
#       define device name for each file, eg: device01.cfg -> device01
#       create branch device01 and push config file into
#       loop all device files
#
# OUTCOME: each device has its own branch and config history
#
# SETUP: create repo in git
#        add deployment key with write permission
#        create empty branch wit nothing then .gitkeep in it
#        update vars according your needs
#        update backup dir with all your current configs
#        call this script
#        verify the results

set -e

########## Define variables
# BRANCH_NAME="$1"
### Remote branch to start with when createing a new backup branch
EMPTY_BRANCH="empty"
# Name of the remote repo, used in url and dir
REPO_NAME="backup.netdev"
# remote repo
REPO_URL="git@git.domain.com:ACME/$REPO_NAME.git"
# where this script is
WD=/etc/ansible/projects/netOps
# where the current backup files are
BACKUP_DIR=$WD/backup
# pattern of backup files for the loop
BACKUP_FILE_PATTERN='*.cfg'
# where the local repo is
REPO_DIR=$WD/$REPO_NAME

### Debug options
# sleep between steps, makes it easy to follow
SLEEP="0.1"

# Change to working dir
cd $WD || exit 1

# Clone the repository
test -d $REPO_DIR || (git clone $REPO_URL -b ${EMPTY_BRANCH} || exit 1)
cd $REPO_DIR || exit 1
git show-ref --quiet refs/heads/${EMPTY_BRANCH} || exit 1 

# Go and list all backu files
cd $BACKUP_DIR || exit 1
for cfg in $BACKUP_FILE_PATTERN
do
  echo "========== $cfg =========="
  sleep $SLEEP
  cfg_dev=$(echo $cfg | rev | cut -d. -f2- | rev)
  BRANCH_NAME=$cfg_dev
  cd $REPO_DIR || exit 1

  # Check if branch already exists
  if git show-ref --quiet refs/heads/${BRANCH_NAME}; then
    echo "Branch ${BRANCH_NAME} already exists. Checking out existing branch."
    sleep $SLEEP
    git checkout ${BRANCH_NAME} >/dev/null
    git pull --force >/dev/null
  else
    # Create new branch
    echo "Creating new branch ${BRANCH_NAME}."
    sleep $SLEEP
    git checkout ${EMPTY_BRANCH} >/dev/null
    git pull --force >/dev/null
    rm -rf $REPO_DIR/* $REPO_DIR/.git???* >/dev/null
    git branch ${BRANCH_NAME} >/dev/null
    git checkout ${BRANCH_NAME} >/dev/null
    git push --set-upstream origin $BRANCH_NAME >/dev/null
    git pull --force >/dev/null
    rm -rf $REPO_DIR/* $REPO_DIR/.git???* >/dev/null
    git push >/dev/null
  fi

  echo "Remove existing files to get ready for new backup file"
  sleep $SLEEP
  rm -rf $BACKUP_FILE_PATTERN .git???* >/dev/null
  echo "Copy new backup file into place"
  cp -av $BACKUP_DIR/$cfg $REPO_DIR/$cfg
  echo "Push backup to remote branch"
  sleep $SLEEP
  git add -A >/dev/null || true
  git commit -a -m "auto backup" >/dev/null || true
  git push >/dev/null
  echo "Cleanup and get ready for new backup"
  sleep $SLEEP
  rm -rfv $BACKUP_FILE_PATTERN .git???*
done

echo "ALL DONE"
