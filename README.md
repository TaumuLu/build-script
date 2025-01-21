# build-script

## use

```bash
DOCKER_IMAGE=''
DOCKER_TAG=''
CF_API_TOKEN=''
CF_ZONE_ID=''
URLS=""

curl -sL https://raw.githubusercontent.com/TaumuLu/build-script/refs/heads/master/build.sh | bash -s -- $DOCKER_IMAGE $DOCKER_TAG
curl -sL https://raw.githubusercontent.com/TaumuLu/build-script/refs/heads/master/cloudflare.sh | bash -s -- purge -t $CF_API_TOKEN -z $CF_ZONE_ID
curl -sL https://raw.githubusercontent.com/TaumuLu/build-script/refs/heads/master/cloudflare.sh | bash -s -- warm -t $CF_API_TOKEN -z $CF_ZONE_ID $URLS

```
