docker-hornetq-2.4.1
============================

Dockerfile running patched HornetQ-2.4.1 for VDAB on Ubuntu 14.04.2 LTS

### Installation
```
docker pull rdehuyss/docker-hornetq-2.4.1
```

Run with 22 and 1099 ports opened:
```
docker run -d -p 49260:22 -p 1099:1099 rdehuyss/docker-hornetq-2.4.1
```

Login by SSH
```
ssh root@localhost -p 49160
password: admin
```
