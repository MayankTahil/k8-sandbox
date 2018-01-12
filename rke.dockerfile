FROM busybox
ENV VERSION v0.0.9-dev
RUN mkdir /data && mkdir /data/ssh-keys
WORKDIR /data
RUN wget "https://github.com/rancher/rke/releases/download/$VERSION/rke_linux-amd64" -O rke && \
		chmod +x rke
VOLUME /data/cluster.yaml
CMD rke up --config cluster.yaml