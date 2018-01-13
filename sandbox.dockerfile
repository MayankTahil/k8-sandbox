FROM alpine

RUN mkdir /data && apk get --no-cache nano git bash
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/darwin/amd64/kubectl && \
	chmod +x ./kubectl && \
	mv ./kubectl /usr/local/bin/kubectl
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh && \
		chmod 700 get_helm.sh && \
		./get_helm.sh
WORKDIR /data

CMD /bin/bash