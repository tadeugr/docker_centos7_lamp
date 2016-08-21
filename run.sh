docker build -t centos7_lamp_v1.0.0 .

docker run \
--name web \
-ti \
-P \
-v /DOCKER_FS:/DOCKER_FS  \
centos7_lamp_v1.0.0
