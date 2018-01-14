FROM busybox
ENV RKE_VERSION v0.0.9-dev
RUN mkdir /data
WORKDIR /data
RUN wget "https://github.com/rancher/rke/releases/download/$RKE_VERSION/rke_linux-amd64" -O rke && \
		chmod +x rke && \
		mv rke /bin/rke
CMD rke up --config cluster.yaml