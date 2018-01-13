FROM docker:17.03-dind

RUN apk add --no-cache \
 sudo \
 curl \
 git \
 screen \
 htop \
 openssh \
 autossh \
 bash-completion \
 nano \
 tcpdump \
 coreutils && \
 # Generate host keys for sshd
 /usr/bin/ssh-keygen -A

# Set container to be a SSH host with pre-seeded SSH keys from git project and prohibit root logon.
RUN mkdir /var/run/sshd && mkdir /keys && \
	 	echo 'root:screencast' | chpasswd && \
 		sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/shadow && \
 		echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
ENV NOTVISIBLE "in users profile"   
RUN echo "export VISIBLE=now" >> /etc/profile && export PATH=$PATH:/usr/sbin

# Add unlocked user "rancher" (sudo) and no ssh keys are retained.
RUN adduser -s /bin/bash -D rancher && \
 adduser rancher root && \
 echo "rancher            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
 mkdir /home/rancher/.ssh && \
 touch /home/rancher/.ssh/authorized_keys

COPY ./ssh-keys/cluster.pub /home/rancher/.ssh/authorized_keys

RUN chown rancher /home/rancher/.ssh/* && \
 		sed -i 's/rancher:!:/rancher::/g' /etc/shadow && \
 		rm -rf /keys/rancher

# RUN sudo mkdir /var/lib/kubelet && sudo mount -o bind /var/lib/kubelet /var/lib/kubelet && sudo mount --make-shared /var/lib/kubelet

CMD sudo mkdir /var/lib/kubelet && sudo mount -o bind /var/lib/kubelet /var/lib/kubelet && sudo mount --make-shared /var/lib/kubelet && /usr/sbin/sshd -D &>/dev/null & /usr/local/bin/dockerd-entrypoint.sh