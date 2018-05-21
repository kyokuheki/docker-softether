# docker-softether
[![](https://img.shields.io/docker/automated/kyokuheki/softether.svg)](https://hub.docker.com/r/kyokuheki/softether/)
[![](https://img.shields.io/docker/stars/kyokuheki/softether.svg)](https://hub.docker.com/r/kyokuheki/softether/)
[![](https://img.shields.io/docker/pulls/kyokuheki/softether.svg)](https://hub.docker.com/r/kyokuheki/softether/)
[![](https://images.microbadger.com/badges/version/kyokuheki/softether.svg)](https://microbadger.com/images/kyokuheki/softether)
[![](https://images.microbadger.com/badges/image/kyokuheki/softether.svg)](https://microbadger.com/images/kyokuheki/softether)

Dockernized Softether container

## Usage

Build docker container

```
docker build . --tag softether
```

For a simple use

```
docker run -d --restart=always --cap-add NET_ADMIN --device=/dev/net/tun --net=host -p443:443 -p992:992 -p5555:5555 -p1194:1194 -p1194:1194/udp -p500:500/udp -p4500:4500/udp -p1701:1701/udp --name softether kyokuheki/softether
```

For a simple use with volumes

```
docker run -d --restart=always --cap-add NET_ADMIN --device=/dev/net/tun --net=host -p443:443 -p992:992 -p5555:5555 -p1194:1194 -p1194:1194/udp -p500:500/udp -p4500:4500/udp -p1701:1701/udp --name softether -v/docker/softether/etc:/etc/vpnserver -v/docker/softether/log:/var/log/vpnserver kyokuheki/softether
```

Configure softether

```
docker exec -it softether /usr/vpnserver/vpncmd localhost /server
docker exec -it softether /usr/vpnserver/vpncmd /tools
docker run --rm -it --net=host kyokuheki/softether config
docker run --rm -it --net=host kyokuheki/softether tools
```
