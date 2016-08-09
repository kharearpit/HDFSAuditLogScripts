#!/bin/bash
value1=$1
value2=$2
target_user="hive"
if [ "$(whoami)" != "$target_user" ]; then
   exec sudo -u "$target_user" /home/hive/zeppelin_tool/zepplin.pl $1 $2
fi
