# asterisk-oracle8-docker
Docker image of Asterisk 18 on Oracle Linux 8

## How to build

1. Change "ARG VERSION=18.10.0" to the newest version, for an instant, "ARG VERSION=18.11.0"

2. Build it 
```
docker image build -t alexshander/asterisk:18.11.0-oracle8 .
docker push alexshander/asterisk:18.11.0-oracle8 
```
For your docker registry you must change alexshander to a name registry of yours.
