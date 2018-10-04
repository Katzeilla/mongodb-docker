#!/bin/bash

# Generate a random password for admin if $MONGODB_ADMIN_PASS not set

if [[ "$ADMIN_PASSWORD" == "" ]]; then 
	ADMIN_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
fi

# Set admin username to admin if $ADMIN_USERNAME not set

if [[ "$ADMIN_USERNAME" == "" ]]; then 
	ADMIN_USERNAME="admin"
fi

# Application Database User


if [[ "$APPLICATION_USERNAME" == "" ]]; then 
	APPLICATION_USERNAME="app"
fi

if [[ "$APPLICATION_DATABASE" == "" ]]; then 
	APPLICATION_DATABASE="app"
fi

if [[ "$APPLICATION_PASSWORD" == "" ]]; then 
	APPLICATION_PASSWORD="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"
fi

# Wait for mongod to boot
Mongod_status=1
while [[ $Mongod_status -ne 0 ]]; do
	      echo "==>  Wait for mongod to boot..."
              sleep 5
	      mongo admin --eval "help" >/dev/null 2>&1
              Mongod_status=$?
done

# Create the admin user
echo "==> Creating admin user with a password in MongoDB"
mongo admin --eval "db.createUser({user: '$ADMIN_USERNAME', pwd: '$ADMIN_PASSWORD', roles:[{role:'root',db:'admin'}]});"

sleep 3

# Create the application user
echo "=> Creating an $APPLICATION_DATABASE user with a password in MongoDB"
mongo admin -u "$ADMIN_USERNAME" -p "$ADMIN_PASSWORD" << EOF
use "$APPLICATION_DATABASE"
db.createUser({user: '"$APPLICATION_USERNAME"', pwd: '"$APPLICATION_PASSWORD"', roles:[{role:'readWrite', db:'"$APPLICATION_DATABASE"'}]})
EOF

sleep 1

# Create a file as flag when finished  
echo "=> Done."

touch /data/db/.mongodb_password_already_set
 
echo "========================================================================"
echo "You may connect to your MongoDB server as admin using:"
echo ""
echo "    mongo admin -u $ADMIN_USERNAME -p $ADMIN_PASSWORD --host <host> --port <port>"
echo ""
echo "Or connect as $APPLICATION_USERNAME using:"
echo ""
echo "    mongo $APPLICATION_DATABASE -u $APPLICATION_USERNAME -p $APPLICATION_PASSWORD --host <host> --port <port>"
echo ""
echo "========================================================================"
