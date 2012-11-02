#!/bin/bash

CURRENT_DIR=`pwd`

REBAR_DIR="$HOME/.rebar"
REBAR_TEMPLATES_DIR="$REBAR_DIR/templates"
REBAR_TEMPLATES_TOOLS="$REBAR_TEMPLATES_DIR/tools"
REBAR_REPO="$REBAR_TEMPLATES_TOOLS/rebar_repo"
REPO_URL=git://github.com/andrzejsliwa/rebar_templates.git

echo "Checking to see if git is installed... "
hash git 2>&- || { echo >&2 "not found.  Aborting installation!'."; exit 1; }
echo "found"

echo "Looking for ~/.rebar directory"
if [ ! -d $REBAR_DIR ]; then
  echo "Not found - initialize."
  mkdir $REBAR_DIR
fi

echo "Looking for an existing templates config..."
TIMESTAMP=`date +%s`
if [ -d $REBAR_TEMPLATES_DIR ]; then
  echo "Found $REBAR_TEMPLATES_DIR. Backing up to $REBAR_TEMPLATES_DIR.pre-install-$TIMESTAMP"
  mv $REBAR_TEMPLATES_DIR $REBAR_TEMPLATES_DIR.pre-install-$TIMESTAMP
fi

echo "Cloning Rebar templates from GitHub... "
/usr/bin/env git clone $REPO_URL $REBAR_TEMPLATES_DIR > /dev/null
echo "done."

echo "Preparing current version of Rebar"
git clone git://github.com/rebar/rebar.git $REBAR_REPO
cd $REBAR_REPO
unset make; make
cp rebar $REBAR_TEMPLATES_TOOLS
cd $CURRENT_DIR
echo "done."

TARGET_RC=.bashrc
echo "updating ~/$TARGET_RC"
echo "
if [ -f "$HOME/.rebar/templates/tools/rebar_rc" ]; then
 source $HOME/.rebar/templates/tools/rebar_rc
fi
" >> ~/$TARGET_RC
echo "done."


echo 'rebar_templates are installed!'
