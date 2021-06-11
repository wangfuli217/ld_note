export TEXE=../sfk

cd ..
rm -rf tmp-selftest-ux
mkdir tmp-selftest-ux
cd tmp-selftest-ux
cp -R ../testfiles testfiles
cp ../scripts/50-patch-all-ux.cpp 50-patch-all-src.cpp

export TCMD="cmp ../scripts/10-sfk-selftest-db.txt"

. ../scripts/12-sub-test-ux.bat
$TEXE syntest

cd ../scripts
