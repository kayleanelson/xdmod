#!/bin/sh
set -e

XDMOD_REALMS=${XDMOD_REALMS:-'jobs,storage,cloud'}
export XDMOD_REALMS

echo "Integration tests beginning:" `date +"%a %b %d %H:%M:%S.%3N %Y"`

UATCU=""
UATXCU=""

# Set output directory
if [ "$1" = "--junit-output-dir" ];
then
    UATCU="--log-junit $2/xdmod-int-uat-cu.xml"
    UATXCU="--log-junit $2/xdmod-int-uat-minus-cu.xml"
fi

cd $(dirname $0)
phpunit="$(readlink -f ../../vendor/bin/phpunit)"

if [ ! -x "$phpunit" ]; then
    echo phpunit not found, run \"composer install\" 1>&2
    exit 127
fi

# Run the tests in UserAdminTest.createUsers
$phpunit --testsuite default --group UserAdminTest.createUsers $UATCU

# Run everything else
$phpunit --testsuite default --exclude-group UserAdminTest.createUsers $UATXCU

./email-subject-test.sh
