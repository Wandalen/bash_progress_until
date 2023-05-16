#!/bin/bash

expect=./tests/file.txt    # reference file

./archive_extract.sh ./tests/ARCH/file.rar   # .rar testing file
current=./tests/ARCH/file.txt
cmp --silent $expect $current && echo '### SUCCESS: RAR archive test done! ###' || echo '### WARNING: RAR archive test wrong! ###'
rm -Rf ./tests/ARCH/file.txt

./archive_extract.sh ./tests/ARCH/file.zip   # .zip testing file
current=./tests/ARCH/file.txt
cmp --silent $expect $current && echo '### SUCCESS: ZIP archive test done! ###' || echo '### WARNING: ZIP archive test wrong! ###'
rm -Rf ./tests/ARCH/file.txt

./archive_extract.sh ./tests/ARCH/file.tar.bz2   # .tar.bz2 testing file
current=./tests/ARCH/file.txt
cmp --silent $expect $current && echo '### SUCCESS: TAR.BZ2 archive test done! ###' || echo '### WARNING: .TAR.BZ2 archive test wrong! ###'
rm -Rf ./tests/ARCH/file.txt


 

