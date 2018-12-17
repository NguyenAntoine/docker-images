#!/bin/sh
BIN_DIR=/usr/local/bin
cd $BIN_DIR

EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
>&2 echo 'ERROR: Invalid installer signature'
rm composer-setup.php
exit 1
fi

php composer-setup.php --install-dir=$BIN_DIR
RESULT=$?
mv $BIN_DIR/composer.phar $BIN_DIR/composer
chmod +x $BIN_DIR/composer
exit $RESULT