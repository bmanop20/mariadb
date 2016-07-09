FROM eboraas/debian:stable
MAINTAINER Manop <b.manop20@gmail.com>

RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db 
RUN apt-get install -y python-software-properties python g++ 
RUN apt-get install software-properties-common
RUN add-apt-repository 'deb http://mariadb.biz.net.id//repo/10.1/debian sid main' 
RUN apt-get update -y && apt-get -y install vim nano  
RUN groupadd -r mysql && useradd -r -g mysql mysql 
RUN  apt-get install -y \
	mariadb-server \
	mariadb-oqraph-engine-10.1 \
	pwgen 
RUN  apt-get autoremove -y \
	&& apt-get autoclean \
	&& apt-get clean \
	&& rm -rf /var/lib/mysql* /var/lib/apt/lists/*


ENV DEBIAN_FRONTEND noninteractive
ENV TERM dumb

ADD config/my.cnf /etc/mysql/my.cnf
ADD config/create_mariadb_admin_user.sh /create_mariadb_admin_user.sh
ADD config/run.sh /run.sh
RUN chmod 775 /*.sh

RUN echo "* soft nofile 1024000" >> /etc/security/limits.conf
RUN echo "* hard nofile 1024000" >> /etc/security/limits.conf
RUN echo "* soft nproc 10240" >> /etc/security/limits.conf
RUN echo "* hard nproc 10240" >> /etc/security/limits.conf

VOLUME  ["/etc/mysql", "/var/lib/mysql"]

EXPOSE 3306

CMD ['/run.sh']
