#! /bin/bash

dir=$(pwd)

date="[$(date)]"


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
	echo "shell                   Attach shell of the running container"
	echo "build	         		Build image from Dockerfile"
	echo "--help, -h ,help                            Show this message"
        echo
        echo "If no [ACTION], start normally"
}

if [[ $1 == network ]]; then
    if [[ $2 != "" ]]; then
        flag="--network $2"
        echo Connect to $2
    fi


elif [[ $1 == debug ]]; then
        flag='--entrypoint /bin/bash'
		echo $date 'Debug Mode'

elif [[ $1 == build ]]; then
        echo $date Start build mongodb
        docker build . --tag mongodb:latest
	exit

elif [[ $1 == shell ]]; then
        echo $date Attach bash in mongodb
 	docker exec -it mongodb bash
        exit

elif [[ $1 == --help ]] || [[ $1 == -h ]] || [[ $1 == help ]]; then
        show_usage
        exit
fi


docker run -it \
  --mount type=bind,source=$dir/data/db,target=/data/db/ \
  --name mongodb \
  $flag \
  mongodb:latest

if [[ $? == 125 ]];
    then
    echo $date "Another mongodb already start, stop it......"
    stop_mongodb
    ./main.sh $1
fi
