#!/bin/sh

./checks/linter.sh || exit 1
./checks/security.sh || exit 1
./checks/test.sh || exit 1
