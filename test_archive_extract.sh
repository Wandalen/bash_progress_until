#!/bin/bash

expect=./tests/file.txt    # reference file

./archive_extract.sh ./tests/ARCH/file.rar   # .rar testing file
current=./tests/ARCH/file.txt
cmp --silent $expect $current && echo '### SUCCESS: RAR archive test done! ###' || echo '### WARNING: RAR archive test wrong! ###'
rm -Rf $current

./archive_extract.sh ./tests/ARCH/file.zip   # .zip testing file
current=./tests/ARCH/file.txt
cmp --silent $expect $current && echo '### SUCCESS: ZIP archive test done! ###' || echo '### WARNING: ZIP archive test wrong! ###'
rm -Rf $current

./archive_extract.sh ./tests/ARCH/file.tar.bz2   # .tar.bz2 testing file
current=./tests/ARCH/file.txt
cmp --silent $expect $current && echo '### SUCCESS: TAR.BZ2 archive test done! ###' || echo '### WARNING: TAR.BZ2 archive test wrong! ###'
rm -Rf $current

./archive_extract.sh ./tests/ARCH/file.tar.gz   # .tar.gz testing file
current=./tests/ARCH/file.txt
cmp --silent $expect $current && echo '### SUCCESS: TAR.GZ archive test done! ###' || echo '### WARNING: TAR.GZ archive test wrong! ###'
rm -Rf $current

./archive_extract.sh ./tests/ARCH/file.tar.xz   # .tar.xz testing file
current=./tests/ARCH/file.txt
cmp --silent $expect $current && echo '### SUCCESS: TAR.XZ archive test done! ###' || echo '### WARNING: TAR.XZ archive test wrong! ###'
rm -Rf $current
 
./archive_extract.sh ./tests/ARCH/file.txt.bz2   # .bz2 testing file
current=./tests/ARCH/file.txt
cmp --silent $expect $current && echo '### SUCCESS: BZ2 archive test done! ###' || echo '### WARNING: BZ2 archive test wrong! ###'
rm -Rf $current

./archive_extract.sh ./tests/ARCH/file.txt.gz   # .gz testing file
current=./tests/ARCH/file.txt
cmp --silent $expect $current && echo '### SUCCESS: GZ archive test done! ###' || echo '### WARNING: GZ archive test wrong! ###'
rm -Rf $current

./archive_extract.sh ./tests/ARCH/file.txt.tar   # .tar testing file
current=./tests/ARCH/file.txt
cmp --silent $expect $current && echo '### SUCCESS: TAR archive test done! ###' || echo '### WARNING: TAR archive test wrong! ###'
rm -Rf $current

./archive_extract.sh ./tests/ARCH/file.tbz2   # .tbz2 testing file
current=./tests/ARCH/file.txt
cmp --silent $expect $current && echo '### SUCCESS: TBZ2 archive test done! ###' || echo '### WARNING: TBZ2 archive test wrong! ###'
rm -Rf $current

./archive_extract.sh ./tests/ARCH/file.tgz   # .tgz testing file
current=./tests/ARCH/file.txt
cmp --silent $expect $current && echo '### SUCCESS: TGZ archive test done! ###' || echo '### WARNING: TGZ archive test wrong! ###'
rm -Rf $current

./archive_extract.sh ./tests/ARCH/file.txt.Z   # .Z testing file
current=./tests/ARCH/file.txt
cmp --silent $expect $current && echo '### SUCCESS: Z archive test done! ###' || echo '### WARNING: Z archive test wrong! ###'
rm -Rf $current

./archive_extract.sh ./tests/ARCH/file.7z   # .7z testing file
current=./tests/ARCH/file.txt
cmp --silent $expect $current && echo '### SUCCESS: 7Z archive test done! ###' || echo '### WARNING: 7Z archive test wrong! ###'
rm -Rf $current

