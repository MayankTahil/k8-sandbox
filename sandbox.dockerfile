FROM alpine

RUN mkdir /data && apk add --no-cache nano git bash curl openssl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
	chmod +x ./kubectl && \
	mv ./kubectl /usr/local/bin/kubectl
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh && \
		chmod 700 get_helm.sh && \
		./get_helm.sh
RUN mkdir /root/.kube
WORKDIR /data
CMD /bin/bash