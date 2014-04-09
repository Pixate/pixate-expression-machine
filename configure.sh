#!/usr/bin/env bash

./prcl src/pixate-expression-machine.xcodeproj headers > Headers.txt
./prcl src/pixate-expression-machine.xcodeproj pixate-expression-machine > Classes.txt

# copy headers

rm -rf Headers
mkdir -p Headers

while read line; do
    cp "src/$line" Headers
done < Headers.txt

cat <<EOF
#
# GNUmakefile
#
ifeq (\$(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := \$(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif
ifeq (\$(GNUSTEP_MAKEFILES),)
 \$(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

include \$(GNUSTEP_MAKEFILES)/common.make

#
# Framework
#
VERSION = 0.1
PACKAGE_NAME = EM
FRAMEWORK_NAME = EM

#
# Resource files
#
EM_RESOURCE_FILES = \\
Resources/Version \\

#
# Header files
#
EM_HEADER_FILES = \\
EOF

# emit header files

while read line; do
    echo "$(basename $line) \\"
done < Headers.txt

cat <<EOF

#
# Class files
#
EM_OBJC_FILES = \\
EOF

# emit class files
while read line; do
  echo "$line \\"
done < Classes.txt

cat <<EOF

#
# Makefiles
#
-include GNUmakefile.preamble
include \$(GNUSTEP_MAKEFILES)/aggregate.make
include \$(GNUSTEP_MAKEFILES)/framework.make
-include GNUmakefile.postamble
EOF
