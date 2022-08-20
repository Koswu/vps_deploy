#!/bin/sh

SCRIPT_DIR=$(dirname $0)
DEST_DIR=${1:-$SCRIPT_DIR/out}
mkdir -p $DEST_DIR

read -p "请输入绑定的域名:" domain
export domain
read -p "请输入 ws 路径:" path
export path
uuid=$(uuidgen)
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


find $DIST_DIR -name '*.in' | xargs sh -c 'replace_var "$@"' 

echo "uuid = $uuid"


