# asterisk-oracle8-docker
Docker image of Asterisk 18 on Oracle Linux 8

## How to build

1. Download it curl http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-18-current.tar.gz -o asterisk-18-current.tar.gz

2. Place asterisk-18-current.tar.gz in the same direcrory with Dockerfile.

3. Change "ARG VERSION=18.10.0" to the newest version, for an instant, "ARG VERSION=18.11.0"

4. Build it 
```
docker image build -t alexshander/asterisk:18.11.0-oracle8 .
docker push alexshander/asterisk:18.11.0-oracle8 
```
For your docker registry you must change alexshander to a name registry of yours.
