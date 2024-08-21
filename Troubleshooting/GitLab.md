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

- [Reset the password of the root account in gitlab in docker]([https://jsonformatter.org/yaml-formatter](https://www.programmerall.com/article/632999018/#:~:text=Reset%20the%20password%20of%20the%20root%20account%20in,in%20to%20the%20server%20with%20root%20privileges%20first.))

[GitLab-DockerCompose](https://www.czerniga.it/2021/11/14/how-to-install-gitlab-using-docker-compose/)
