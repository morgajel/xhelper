#!/bin/bash

# Setting our display to the most common value. If you can think of a reason to change this, let me know.
export DISPLAY=localhost:10.0


if [[ $# < 2 ]] ; then
    echo ERROR: xhelper requires two arguments.
    echo "    Usage:"
    echo "      ./xhelper.sh jboss /usr/java/latest/bin/jvisualvm"
fi

# Grab the latest xauth ID from the list (note that these may build up over time; you may want to check that.
export MYID=`/usr/bin/xauth list|awk '{print $1}'|sort -n|head -n 1`

# we switch to /tmp in case the app (like jmeter) wants to write temp files to the local dir; this makes it more likely to work.
# I'm open to better suggestions.
cd /tmp

# Merge your latest xauth ID into the user's xauth list...
/usr/bin/xauth extract - ${MYID} |/usr/bin/sudo -u $1 -H /usr/bin/xauth merge - &&\
# and run the app and it's parameters
/usr/bin/sudo -u $1 -H -E "${@:2}"

# attempt to clean up after yourself...
/usr/bin/sudo -u $1 -H /usr/bin/xauth remove ${MYID}
