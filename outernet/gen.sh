#!/bin/bash

SCRIPT_DIR=$(dirname $0)
DEST_DIR=${1:-"$SCRIPT_DIR/out"}
mkdir -p $DEST_DIR

read -p "请输入绑定的域名:" domain
export domain
read -p "请输入 ws 路径:" path
export path
uuid=$(cat /proc/sys/kernel/random/uuid)
export uuid

escape_path_slash() {
	echo ${1//\//\\\/}
}
export -f escape_path_slash

replace_var() {
	sed "{s/\[DOMAIN\]/$domain/;s/\[PATH\]/$(escape_path_slash $path)/;s/\[UUID\]/$uuid/}"  $1 > ./${1%%.in}
}
export -f replace_var


cp -r $SCRIPT_DIR/src/* $DEST_DIR


for template_file in $(find $DEST_DIR -name '*.in')
do
	echo $template_file
	replace_var $template_file
done;

echo "uuid = $uuid"


