# Watchtower with python

The goal of this image is to allow for GCR credential helpers in a Google Cloud environment (on debian). Here's an example compose config:

> :warning: Make sure to disable watchtower for any non-gcr images. Because of the way watchtower uses credential stores, it can only enable the helper for all images or for none at all. If you wish to update the other images too, try adding a separate instance of watchtower without a helper enabled.


```
# docker-compose.yml
version: "3.4"
services:
  app:
    image: gcr.io/<project>/<image>:latest
  watchtower:
    image: yspreen/watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /root/.docker/config.json:/config.json
      - /root/.config/gcloud:/.config/gcloud
      - /usr/lib/google-cloud-sdk:/usr/lib/google-cloud-sdk
    command: --cleanup --interval 10
    environment:
      - PATH=$PATH:/usr/lib/google-cloud-sdk/bin
      - HOME=/
    labels:
      - com.centurylinklabs.watchtower.enable=false
  nginx:
    image: jonasal/nginx-certbot:latest
    restart: unless-stopped
    env_file:
      - ./nginx-certbot.env
    ports:
      - 80:80
      - 443:443
    volumes:
      - nginx_secrets:/etc/letsencrypt
      - ./user_conf.d:/etc/nginx/user_conf.d
    labels:
      - com.centurylinklabs.watchtower.enable=false

volumes:
  nginx_secrets:
```

Config file:
```
{
  "credsStore": "gcloud",
  "credHelpers": {
    "gcr.io": "gcloud",
    "us.gcr.io": "gcloud",
    "eu.gcr.io": "gcloud",
    "asia.gcr.io": "gcloud",
    "staging-k8s.gcr.io": "gcloud",
    "marketplace.gcr.io": "gcloud"
  }
}
```
