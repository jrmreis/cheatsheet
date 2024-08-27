# GitLab - Docker

## Comandos de reset de senha on premises
- `docker ps` - exibe todos os containers em execução no momento.
- `docker exec -it gitlab bash` - entra no container de nome 'gitlab', no modo iterativo em um shell.
- `gitlab-rails console -e production` - abre o console gitlab-rails
- `user = User.where(id: 1).first` - seleciona o user 'root'.
- `user.password = 'secret_pass@123'` - entra com senha do user 'root'.
- `user.password_confirmation = 'secret_pass@123'` - confirma nova senha do user 'root'.
- `user.save!` - salva as alterações.
- `exit` - sai da console.

[Reset the password of the root account in gitlab in docker](https://www.programmerall.com/article/632999018/#:~:text=Reset%20the%20password%20of%20the%20root%20account%20in,in%20to%20the%20server%20with%20root%20privileges%20first)

## Comandos de registro gitlab-runner on premises (docker)
- `docker ps` - exibe todos os containers em execução no momento.
- `docker network inspect gitlab-network | grep Gateway` - retorna o ip de gateway, que neste caso irá se comunicar com 'hoster' ex."Gateway": "172.18.0.1".
- `docker exec -it gitlab-runner1 bash` - entra no container de nome 'gitlab-runner1', no modo iterativo em um shell.
- `gitlab-runner1:/# gitlab-runner register --url http://172.18.0.1 --token glrt-9_f5MYx4NNLpy7effAN1` - entre com os dados de URL que está publicado o gitLab on premises e o token de gitlab-runner.
- Se tudo funcionar bem será exibido a seguinte mensagem: 
```
Enter the default Docker image (for example, ruby:2.7):
gitlab/gitlab-runner:alpine
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
Configuration (with the authentication token) was saved in "/etc/gitlab-runner/config.toml"
```
[GitLab-DockerCompose](https://www.czerniga.it/2021/11/14/how-to-install-gitlab-using-docker-compose/)

## Gitlab-runner (docker) não encontra o repositório para executar o Job CI.

- `docker logs gitlab-runner1` - retornará o log do gitlab-runner, abaixo, as primeiras linhas, mostram o ERRO - a requisição está equivocada.

```
ERROR: Checking for jobs... forbidden               runner=9_f5MYx4N status=POST http://172.18.0.1/api/v4/jobs/request: 403 Forbidden
ERROR: Checking for jobs... forbidden               runner=9_f5MYx4N status=POST http://172.18.0.1/api/v4/jobs/request: 403 Forbidden
ERROR: Runner "http://172.18.0.19_f5MYx4N" is unhealthy and will be disabled for 1h0m0s seconds!  unhealthy_requests=3 unhealthy_requests_limit=3
Checking for jobs... received                       job=281 repo_url=http://172.17.0.1/root/test-project.git runner=zKBHqxyP
Added job to processing list                        builds=1 job=281 max_builds=1 project=2 repo_url=http://172.17.0.1/root/test-project.git time_in_queue_seconds=1
Appending trace to coordinator...ok                 code=202 job=281 job-log=0-683 job-status=running runner=zKBHqxyP sent-log=0-682 status=202 Accepted update-interval=3s
Appending trace to coordinator...ok                 code=202 job=281 job-log=0-2015 job-status=running runner=zKBHqxyP sent-log=683-2014 status=202 Accepted update-interval=3s
Appending trace to coordinator...ok                 code=202 job=281 job-log=0-2618 job-status=running runner=zKBHqxyP sent-log=2015-2617 status=202 Accepted update-interval=3s
```
- `ifconfig` - retornará diversas infos de rede, neste caso será utilizado o IP do docker0:
```
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        inet6 fe80::42:49ff:fe32:ed33  prefixlen 64  scopeid 0x20<link>
        ether 02:42:49:32:ed:33  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 59  bytes 7670 (7.6 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```
utilizar o IP docker0, neste caso 172.17.0.1, como hostname do gitlab-web, normalmente "localhost", no arquivo `docker-compose.yml`:

```
services:

  # GITLAB
  gitlab-web:
    image: 'gitlab/gitlab-ce:latest'
    restart: always
    container_name: gitlab-web
    hostname: '172.17.0.1'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://172.17.0.1/'
        gitlab_rails['gitlab_shell_ssh_port'] = 2222
        ##optional:
        #sidekiq['max_concurrency'] = 10
        #prometheus_monitoring['enable'] = false
        #gitlab_rails['registry_enabled'] = true
        #gitlab_rails['registry_host'] = "http://registry.local.mydomain.tld"
        #external_url 'https://gitlab.local.mydomain.tld'
        #nginx['listen_port'] = 80
        #nginx['listen_https'] = false
        #letsencrypt['enable'] = false
        #gitlab_rails['gitlab_shell_ssh_port'] = 9999
        #registry_external_url 'http://registry.local.mydomain.tld/'
        #registry_nginx['listen_https'] = false
        #registry_nginx['proxy_set_headers'] = {
        #    "X-Forwarded-Proto" => "https",
        #    "X-Forwarded-Ssl" => "on"
        #}
    ports:
      - "80:80"
      - "443:443"
      - "2222:22"
    volumes:
      - './gitlab/config:/etc/gitlab'
      - './gitlab/logs:/var/log/gitlab'
      - './gitlab/data:/var/opt/gitlab'
    networks:
      - gitlab-network

  # RUNNER
  gitlab-runner1:
    image: gitlab/gitlab-runner:alpine
    restart: always
    container_name: gitlab-runner1
    hostname: gitlab-runner1
    depends_on:
      - gitlab-web
    volumes:
     - ./config/gitlab-runner:/etc/gitlab-runner
     - /var/run/docker.sock:/var/run/docker.sock
    networks:
        - gitlab-network

  

networks:
  gitlab-network:
    name: gitlab-network
```



[StackOverFlow - docker0 vs localhost](https://stackoverflow.com/questions/34003101/gitlab-runner-unable-to-clone-repository-via-http)
