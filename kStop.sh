#!/bin/bash

fuser -k 2181/tcp &&
fuser -k 9092/tcp &
sleep 5
cd ~/kafka_2.11-2.1.1 &&
sudo bin/zookeeper-server-stop.sh config/zookeeper.properties &
sleep 5 &&
cd ~/kafka_2.11-2.1.1 &&
sudo bin/kafka-server-stop.sh config/server.properties