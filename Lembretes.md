# Comandos WSL no powershell ADM:

## Linux Restart:
```
Get-Service LxssManager | Restart-Service
```

## Conexão wsl externa para outra máquina:

```
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=22 connectaddress=13.68.0.148 connectport=22`
```

fonte: https://www.hanselman.com/blog/how-to-ssh-into-wsl2-on-windows-10-from-an-external-machine

## Desligar:

```
wsl.exe --shutdown`
```

## Mapeando (rede) wsl 2 para acesso no windows via powershell ADM:

```
net use Z: \\wsl$\Ubuntu-20.04 /PERSISTENT:YES`
```

# Comandos linux:

## Atualizar:

```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt-get install checkinstall
```

## Processos Zombie:
```
ps axo stat,ppid,pid,comm | grep -w defunct
```
```
sudo kill -9 3376
```

## Restart com timer:
```
sudo shutdown -r +10
```

## Cancelar restart com timer:

``` 
sudo shutdown -c
```

## Colocando programa em Back Ground:

``` 
./prog.sh &
```

# Listar:
## Listando programa(s) em Back Ground:

``` 
jobs
```
## Pid dos programa(s) em Back Ground:

``` 
jobs -p
```
## Parar os programa(s) em Back Ground:

``` 
jobs -p | xargs -I{} kill -- -{}
```
## Parar os programa(s) em Back Ground stoped:

``` 
kill -9 `jobs -ps`
```
## Kill os programa(s) em Back Ground:
```
kill -9 $(jobs -p)
```
## Listando programa(s) usando determinada porta:
```
lsof -w -n -i tcp:9092
```
fuser -n tcp 9092
```
lsof -w -n -i tcp:2181
```
