# Jekyll Docker Container

![](https://raw.githubusercontent.com/eneus/jekyll/dev/src/demo/images/logos/jekyll_logo.png) + ![](https://raw.githubusercontent.com/eneus/jekyll/dev/src/demo/images/logos/compass_logo.png) + ![](https://avatars3.githubusercontent.com/u/22247014?s=254&v=3)

Jekyll Docker Container with Demo Content and demo site.
## The first of all:
##### Install Docker:
    - On Linux Ubuntu/Debian:
        https://docs.docker.com/install/linux/docker-ce/ubuntu/ 
				https://docs.docker.com/install/linux/docker-ce/debian/
    - On MacOS:
        https://docs.docker.com/docker-for-mac/install/
    - On Windows:
        https://docs.docker.com/docker-for-windows/install/

##### Install Docker Compose:
    https://docs.docker.com/compose/install/

##### download repository:

```
git clone git@github.com:eneus/jekyll.git
```

##### Go to downloaded folder:

```
cd jekyll
```

##### Configure your .env file:

```
COMPOSE_FILE=./configs/docker-compose.yml
COMPOSE_PROJECT=demo           # Folder  (src/${COMPOSE_PROJECT}), config file ${COMPOSE_PROJECT}.yml,
COMPOSE_PROJECT_NAME=demo      # short name used in container name Ex.: demo_jekyll
SITE_NAME=Demo Content
SITE_MAIL=admin@demosite.com

IPRANGE=192.168.16.0/20
CUID=1000
CGID=1000
```

##### Start docker container via Makefile:

```
$ make all
or
docker-compose up -d     //in background
```

##### Start docker container via docker-compose:

```
docker-compose up
or
docker-compose up -d     //in background
```

##### Now you can access to you static site:

```
http://localhost:4000  Jekyll Server
```

Image Credits: http://gratisography.com/ , http://gratisography.com/