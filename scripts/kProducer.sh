#!/bin/bash

VARIAVEL_IP="$1"

VARIAVEL_TOPIC="$2"

cd ~/kafka_2.11-2.1.1 && sudo bin/kafka-console-producer.sh --broker-list $1:9092 --topic $2