#!/bin/bash -e

# args
# SYSTEM COMMUNITY BROWSER SUITE_NAME CHROME_PID
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"

export no_proxy=sap.corp,.mo.sap.corp,10.*,localhost,127.0.0.1,0.0.0.0
export http_proxy=http://proxy.wdf.sap.corp:8080
export https_proxy=http://proxy.wdf.sap.corp:8080
export TERM=xterm

SYSTEM="${1:-integration}"
COMMUNITY="${2:-nike}"
BROWSER="${3:-firefox}"
SUITE_NAME="${4:-watir:test_p1}"
CHROME_PORT="${5:-9812}"

rvm use 2.2.1@$JOB_NAME --create

# kill existing chromedriver
# TODO this should move to the suite itself
CHROME_PID=ps aux | grep '[c]hromedriver.*$CHROME_PORT' | awk '{print $2}'
echo "CHROME_PID: $CHROME_PID"
[ ! -z "$CHROME_PID" ] &&  $CHROME_PID | xargs kill -9

bundle install
bundle exec xvfb-run -a -s "-screen 0 1280x1024x24" rake $SUITE_NAME[$SYSTEM,$COMMUNITY,$BROWSER] --trace