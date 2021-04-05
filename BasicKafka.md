# Comandos básicos Kafka no terminal:

## Iniciar o Zookeeper

`./zookeeper-server-start.sh ../config/zookeeper.properties`

## Iniciar o Kafka:

`./kafka-server-start.sh ../config/server.properties`

## Criar um Tópico:

`./kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 2 --topic power_guido`

## Iniciar um Consumer (listener) no tópico definido:

`./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic power_guido --group topic_group`

## Listar todos os tópicos:

`./kafka-topics.sh --list --zookeeper localhost:2181`

fonte: https://dzone.com/articles/apache-kafka-basic-setup-and-usage-with-command-li
