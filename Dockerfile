FROM ubuntu:14.04.2

# patched hornetq-2.4 for VDAB based on Ubuntu 14.04.2
MAINTAINER Ronald Dehuysser <ronald.dehuysser@vdab.be>

# apt-get update & upgrade and fix pam; see https://github.com/docker/docker/issues/5704
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get -y build-dep pam
#Rebuild and istall libpam with --disable-audit option
RUN export CONFIGURE_OPTS=--disable-audit && cd /root && apt-get -b source pam && dpkg -i libpam-doc*.deb libpam-modules*.deb libpam-runtime*.deb libpam0g*.deb

# Install sshd
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:admin' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN echo "export VISIBLE=now" >> /etc/profile

# Prepare to install Hornetq
RUN apt-get install -y libaio1 net-tools bc
RUN ln -s /usr/bin/awk /bin/awk
RUN mkdir /var/lock/subsys

# Install JAVA
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN apt-get install oracle-java8-installer -y
RUN apt-get install oracle-java8-set-default

# Expose hornetq
ADD hornetq-2.4.1.Final /opt/hornetq-2.4.1.Final
ADD hornetq  /etc/init.d/hornetq

RUN chmod a+x /etc/init.d/hornetq
RUN chmod a+x /opt/hornetq-2.4.1.Final/bin/*.sh
RUN echo 'export HORNETQ_HOME=/opt/hornetq-2.4.1.Final' >> /etc/bash.bashrc
RUN echo 'export PATH=$HORNETQ_HOME/bin:$PATH' >> /etc/bash.bashrc

# Expose ports
EXPOSE 22
EXPOSE 1099

CMD service hornetq start; \
	/usr/sbin/sshd -D
