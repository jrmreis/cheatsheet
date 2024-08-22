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
`Enter the default Docker image (for example, ruby:2.7):
gitlab/gitlab-runner:alpine
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
Configuration (with the authentication token) was saved in "/etc/gitlab-runner/config.toml"`

[GitLab-DockerCompose](https://www.czerniga.it/2021/11/14/how-to-install-gitlab-using-docker-compose/)
