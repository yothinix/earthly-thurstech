# Earthly demo for ThursTech
This project is for demonstrate how to evolved from single Dockerfile to Earthfile on a simple Django/Python project with GitHub action as CI

## The demo
* The Event video: TBA
* All the demo code: [https://github.com/yothinix/earthly-thurstech](https://github.com/yothinix/earthly-thurstech)
* The slide: [https://bit.ly/earthly-thurstech](https://bit.ly/earthly-thurstech)

## Prerequisite
  * Docker runtime -- I recommend [colima](https://github.com/abiosoft/colima) alternative to [Docker Desktop](https://docs.docker.com/desktop/install/mac-install/), Please note that you need to enable buildkit via environment variable `DOCKER_BUILDKIT=1` 
  * [Earthly](https://earthly.dev)

## Working with Earthly
You can execute a single target in Earthly like below
```
earthly +lint
```
If the target required image to be push to Docker registry you need to add `--push` option when executing target, otherwise Earthly will save image only in local, for example
```
earthly --push +publish
```
If the target use a Docker inside Docker mechanism you need to add `--allow-privileged` option when executing target, for example
```
earthly --allow-privileged +verify
```
