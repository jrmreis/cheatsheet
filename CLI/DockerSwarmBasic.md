# Docker Swarm:

- `docker-machine create vm1 --virtualbox-no-vtx-check` - cria docker vm
- `docker-machine ssh vm1` - acessa a vm1
- `docker info` - mostra se a vm faz parte de uma swarm (cluster)
- `docker swarm join-token worker` - na vm manager, token para add workers, copier o token da vm1 e colar logado nas vms workers.
- `docker node ls` - lista os nós do swarm (cluster), somente na vm manager
- `docker swarm leave` - deixar o status down na lista “Docker node ls”
- `docker node rm <id>` - remove da swarm
- `docker node inspect vm2` - descobre o IP dessa vm
- `docker@vm2:~$ docker container run -p 8080:3000 -d aluracursos/barbearia`   - carrega a imagem para o container vm2
- `docker container ls` - lista os containers na vm específica
- `docker@vm2:~$ docker container rm 38f –force`  - remover container
- `docker@vm1:~$ docker service create -p 8080:3000 aluracursos/barbearia`  - cria um serviço no cluster, e inicia-o
- `docker@vm1:~$ docker service create -p 8080:3000 --mode global aluracursos/barbearia`  - cria um serviço no cluster, que vai rodar um em cada nó (levatará uma instância em cada nó).
- `docker@vm1:~$ docker service ls` - lista os serviços


## criando um backup do swarm:
- `docker@vm1:~$ sudo su`  - super usr
- `root@vm1:/home/docker# cd /var/lib/docker/swarm`  - acesso à backup do swarm (vm1 – manager)
- `root@vm1:/var/lib/docker/swarm# ls`
certificates       raft               worker
docker-state.json  state.json
- `root@vm1:/var/lib/docker/swarm# cd`
- `root@vm1:~# cp -r /var/lib/docker/swarm/ backup`
- `root@vm1:~# ls`
backup

## copiando o backup para o swarm:
- `root@vm1:~# cp -r backup/* /var/lib/Docker/swarm`
- `root@vm1:~# docker swarm init –force-new-cluster –advertise-addr 192.168.99.112` dessa forma não há necessidade de colocar os worker via token! (no caso de uma tragédia na vm1 manager)
- `docker node demote vm1`  - rebaixa a patente, para poder remover
- `docker service rm $(Docker service ls -q)` - remove todos os serviços de uma vez (aceito em um manager)
- `docker node update  --availability drain vm2` - protege a vm2 indisponível para execução de tarefas
- `docker service update --constaint-add node.role==worker` - só alocará o serviço em workers
- `docker service update --constraint-add node.hostname==vm4 ci10k3u7q6ti`
- `docker service update --constraint-rm node.id==t76gee19fjs8 ci10k3u7q6ti`

- `docker service update --constraint-rm node.hostname==vm4 ci10k3u7q6ti`

- `docker network ls` - mostra todas as redes (drivers)

Fonte: curso [Docker Swarm - Alura](https://cursos.alura.com.br/course/docker-swarm-cluster-container)
