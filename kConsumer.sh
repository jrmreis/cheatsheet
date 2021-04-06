#!/bin/bash

VARIAVEL_IP="$1"

VARIAVEL_TOPIC="$2"


cd ~/kafka_2.11-2.1.1 && bin/kafka-console-consumer.sh --bootstrap-server $1:9092 --topic $2 --from-beginning
