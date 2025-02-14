# build-script

## use

### Docker build

```bash
DOCKER_IMAGE=''
DOCKER_TAG=''
HOST_PORT=''
CONTAINER_PORT=''

curl -sL https://raw.githubusercontent.com/TaumuLu/build-script/refs/heads/master/build.sh | bash -s -- $DOCKER_IMAGE -t $DOCKER_TAG -p $HOST_PORT:$CONTAINER_PORT
```

### cloudflare purge & warm

```bash
CF_API_TOKEN=''
CF_ZONE_ID=''
URLS=""

curl -sL https://raw.githubusercontent.com/TaumuLu/build-script/refs/heads/master/cloudflare.sh | bash -s -- purge -t $CF_API_TOKEN -z $CF_ZONE_ID
curl -sL https://raw.githubusercontent.com/TaumuLu/build-script/refs/heads/master/cloudflare.sh | bash -s -- warm -t $CF_API_TOKEN -z $CF_ZONE_ID $URLS
```
