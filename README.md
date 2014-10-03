Docker Metasploit Framework
=============================

From Docker Index
```
docker pull usertaken/metasploit-framework
```

Build Yourself
```
docker build --rm -t usertaken/metasploit-framework github.com/UserTaken/docker-metasploit-framework
```

Run
```
docker run -d -it -p 4444:4444 usertaken/metasploit-framework
```
