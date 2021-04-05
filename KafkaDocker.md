# Comandos kafka para **Docker** (na raiz):

## Criar novo tópico :
./usr/bin/kafka-topics \\
--bootstrap-server zookeeper:2181 \\
--create \\
--topic __my-first-topic__ \\
--partitions 3 \\
--replication-factor 1

## Criar novo tópico, se não existir (na raiz):
./usr/bin/kafka-topics \
--bootstrap-server zookeeper:2181 \
--create --topic my-first-topic \
--partitions 3 \
--replication-factor 1 \
--if-not-exists

## Listar tópicos kafka:
./usr/bin/kafka-topics \
--bootstrap-server zookeeper:2181 \
--list

## Exclude listing of external topics like “__consumer_offsets”
./usr/bin/kafka-topics \
--bootstrap-server zookeeper:2181 \
--list \
--exclude-internal

## Detalhar tópicos:
./usr/bin/kafka-topics \
--bootstrap-server zookeeper:2181 \
--topic my-first-topic \
--describe

## Aumentar o número de partições:
./usr/bin/kafka-topics \
--bootstrap-server zookeeper:2181 \
--alter \
--topic my-first-topic \
Note:
The number of partitions for a topic can only be increased.
If partitions are increased for a topic that has a key, the partition logic or ordering of the messages will be affected.--partitions 5

## Tempo de retenção de um tópico (259200000 ms = 3 days - default retention period of a Kafka topic is seven days):
./usr/bin/kafka-configs \
--bootstrap-server zookeeper:2181 \
--alter \
--entity-type topics \
--entity-name my-first-topic \
--add-config retention.ms=259200000

## Purgar tópicos:
./usr/bin/kafka-configs \
--bootstrap-server zookeeper:2181 \
--alter \
--entity-type topics \
--entity-name my-first-topic \
--add-config retention.ms=1000

aguardar 1 minuto, e depois:

./usr/bin/kafka-configs \
--bootstrap-server zookeeper:2181 \
--alter --entity-type topics \
--entity-name my-first-topic \
--delete-config retention.ms

## Mostrar configurações do tópico:
./usr/bin/kafka-configs \
--bootstrap-server zookeeper:2181 \
--describe \
--entity-type topics \
--entity-name my-first-topic 

## Deletar tópicos:
./usr/bin/kafka-topics \
--bootstrap-server zookeeper:2181 \
--delete \
--topic my-first-topic

## Produzir msgs:
./usr/bin/kafka-console-producer \
--broker-list localhost:9092 \
--topic my-first-topic

## Produzir msgs (.txt):
./usr/bin/kafka-console-producer \
--broker-list localhost:9092 \
--topic my-first-topic < C:\\Users\\Joel\\topic-input.txt

## Produzir msgs com Value e Key personalizados:
./usr/bin/kafka-console-producer \
--broker-list localhost:9092 \
--topic some-topic \
--property parse.key=true \
--property key.separator=*
>key:value
>foo:bar
>anotherKey:another value

## Consumir tópicos mostrando somente os valores:
./usr/bin/kafka-console-consumer \
--bootstrap-server localhost:9092 \
--topic my-first-topic

## Consumir tópicos mostrando além dos valores as chaves tbm:
./usr/bin/kafka-console-consumer \
--bootstrap-server localhost:9092 \    
--topic some-topic \
--formatter kafka.tools.DefaultMessageFormatter \
--property print.key=true \ 
--property print.value=true


## Consumir tópicos do começo:
./usr/bin/kafka-console-consumer \
--bootstrap-server localhost:9092 \
--topic my-first-topic \
--from-beginning

## Encontrar todas as partições que não estão sincronizadas com o lider:
./usr/bin/kafka-topics \
--bootstrap-server zookeeper:2181 \
--describe \
--under-replicated-partitions

## Consultar Versão do Kafka:
./usr/bin/kafka-broker-api-versions \
--bootstrap-server localhost:9092 \
--version

## Desligar o Kafka:
docker-compose down -v

## PRODUCER PERFORMANCE TEST:
./usr/bin/kafka-producer-perf-test \
--topic perf \
--num-records 1000000 \
--throughput 100000 \
--record-size 1000 \
--producer-props \
bootstrap.servers=localhost:9092

## CONSUMER PERFORMANCE TEST:
./usr/bin/kafka-consumer-perf-test \
--broker-list localhost:9092 \
--topic perf \
--messages 10000

./usr/bin/kafka-consumer-perf-test \
--broker-list localhost:9092 \
--topic perf \
--messages 100000

fonte: https://www.youtube.com/watch?v=gonVzrQ-azY


