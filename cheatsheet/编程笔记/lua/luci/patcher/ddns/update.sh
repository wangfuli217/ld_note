#!/bin/bash

TMP_DIR="_pack"
FILE_LIST="_flist"
SRC="new"

set_src() {
	SRC="${1}"
	echo "#below for build ${1}:" >> ./"${FILE_LIST}"
}
#install_data <dst_path> <src_name=dst_name> [dst_name]
install_data() {
	local dst="./${TMP_DIR}/${1}"
	local fname=${2}
	mkdir -p "${dst}"
	cp -a ${SRC}/${fname} ${dst}/${3}
	[ -z "${3}" ] || fname="${3}"
	echo "${1}/${fname}" >>./"${FILE_LIST}"
}

install_bin() {
	local dst="./${TMP_DIR}/${1}"
	local fname=${2}
	mkdir -p "${dst}"
	cp -a ${SRC}/${fname} ${dst}/${3}
	[ -z "${3}" ] || fname="${3}"
	chmod 755 ${dst}/${fname}
	echo "${1}/${fname}" >>./"${FILE_LIST}"
}

pack() {
	local pack_name=${1}
	echo "Press enter to pack to prepare ${SRC} package \"${pack_name}\""
	read
	pushd ./${TMP_DIR}
	tar -cvz -f "../${pack_name}" .
	popd
	echo "Press enter to send \"${pack_name}\" to router wnddr4300:/tmp ..."
	read
	scp ./${pack_name} wndr4300:/tmp
	echo tar -xvz -f /tmp/${pack_name} -C / >>_cmds.sh
	rm -rf ./${TMP_DIR}
}

build_pull() {
	local fname=${1}
	echo -e "Press enter to send backup pull list \"${FILE_LIST}\" to router wnddr4300:/tmp ...\n$(cat ./${FILE_LIST})"
	read
	scp ./${FILE_LIST} wndr4300:/tmp
	echo tar -cvzT "/tmp/${FILE_LIST}" -f "/tmp/${fname}" -C / >>_cmds.sh
}


echo "Press enter to gen patch files to ./patch"
read
rm -rf ./patch
mkdir ./patch
for fname in $(cd new;ls -1 *); do
diff -NpruEbBd "old/${fname}" "new/${fname}" >./patch/"${fname}.patch"
done
ls ./patch/*.patch

echo "Press enter to pack to prepare package ..."
read
rm -rf "./${TMP_DIR}"
mkdir -p "./${TMP_DIR}"
rm -rf ./"${FILE_LIST}"
for line in "$(cat update.lst)"; do
	eval "${line}"
done
