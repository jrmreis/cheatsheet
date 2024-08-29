#!/bin/bash

fuser -k 2181/tcp &&
fuser -k 9092/tcp &
sleep 5
cd ~/kafka_2.11-2.1.1 &&
sudo bin/zookeeper-server-start.sh config/zookeeper.properties &
sleep 5 &&
cd ~/kafka_2.11-2.1.1 &&
sudo bin/kafka-server-start.sh config/server.properties
