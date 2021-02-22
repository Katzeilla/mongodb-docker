#! /bin/bash

stop_mongodb()
{
    docker stop mongodb
    docker rm mongodb
}

show_usage()
{
        echo "This is a bash script for manage MongoDB"
        echo "./main [ACTION]"
        echo
        echo "ACTION:"
        echo
	echo "network <network_name>		       Connect to a network"
	echo "debug                                        Start in to bash"
	echo "purge     Stop and remove container, then delete all database"
	echo "shell                   Attach shell of the running container"
	echo "build	         		Build image from Dockerfile"
	echo "--help, -h ,help                            Show this message"
        echo
        echo "If no [ACTION], start normally"
}

if [[ "$1" == network ]]; then
    if [[ "$2" != "" ]]; then
        flag="--network $2"
        echo "Connect to $2"
    fi


elif [[ "$1" == debug ]]; then
        flag='--entrypoint /bin/bash'
	echo 'Debug Mode'

elif [[ "$1" == build ]]; then
        echo Start build mongodb
        docker build . --tag mongodb:latest
	exit

elif [[ "$1" == shell ]]; then
        echo Attach bash in mongodb
 	docker exec -it mongodb bash
        exit

elif [[ "$1" == purge ]]; then
        echo WARNING!! This will delete all database!
	docker stop mongodb
        docker rm mongodb
	sudo rm -r ./data/db
	mkdir ./data/db/
	touch ./data/db/.dirkeeper
	echo Done!
        exit

elif [[ "$1" == --help ]] || [[ "$1" == -h ]] || [[ "$1" == help ]]; then
        show_usage
        exit
fi

# shellcheck disable=SC2086
# $flag can't be double quoted
docker run -it \
  --mount type=bind,source="$(pwd)"/data/,target=/data/ \
  --name mongodb \
  $flag \
  mongodb:latest

