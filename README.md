Involves terraform to create AWS service instances on floci.

Using golang or any language to interact with any floci AWS services such as rabbit MQ.


# Setting up proxy to connect to amazon mq broker on docker

```
docker run -d --name floci-amqp-proxy \
  --network flociplayground_default \
  -p 5672:5672 \
  alpine/socat \
  TCP-LISTEN:5672,fork,reuseaddr \
  TCP:<broker-container>:5672
```