# jekyll
Jekyll Docker Container with Fish content
## The first of all:
##### Install Docker:
    - On Linux Ubuntu/Debian:
        https://docs.docker.com/installation/ubuntulinux/
    - On MacOS:
        https://docs.docker.com/installation/mac/
        https://docs.docker.com/installation/mac/#from-your-shell // see bellow page "How to run docker on OS X"
    - On Windows:
        https://docs.docker.com/installation/windows/

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