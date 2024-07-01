# Docker image for running react-pulse-mixer

This docker image is the preferred way to deploy [react-pulse-mixer](https://github.com/christianglodt/react-pulse-mixer).

To run react-pulse-mixer, create a `docker-compose.yml` file like this:

```yaml
services:
  react-pulse-mixer:
    image: ghcr.io/christianglodt/react-pulse-mixer-docker
    environment:
      PULSE_SERVER: server.lan
    ports:
      - "5000:80"
```

Multiple instances can be created by repeating the service in the docker-compose.yml
file. In that case, care must be taken to use a distinct service name, container_name
and port for each instance.

The PULSE_SERVER environment variable defines the host whose PulseAudio
instance you would like to control. Note that the native PulseAudio network protocol
must be enabled on the machine (see the
[PulseAudio documentation](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Modules/#module-native-protocol-unixtcp)
for configuration options).

react-pulse-mixer does not provide any authentication. Authentication should be
handled by the reverse proxy. It only uses relative paths, and can thus be mapped
to any prefix in your url namespace.

Configuring an Nginx reverse proxy can be done trivially with a directive like
the following:
```
location /mixer/ {
    proxy_pass http://localhost:5000/;
}
```
