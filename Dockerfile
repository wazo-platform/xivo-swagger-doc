FROM nginx:latest
MAINTAINER XiVO Team "dev@avencall.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update
RUN apt-get -qq -y install git python-pip

#Fetch latest version of xivo-swagger-doc
WORKDIR /root
RUN git clone --depth 1 "git://github.com/xivo-pbx/xivo-swagger-doc"

#Clone all projects containing a swagger API.
#List of projects is in xivo-swagger-doc/contrib/repos
RUN mkdir /root/projects
WORKDIR /root/projects
RUN for url in $(cat /root/xivo-swagger-doc/contribs/repos); do git clone --depth 1 $url ; done

#Build static version of documentation and install it
WORKDIR /root/xivo-swagger-doc
RUN pip install -r utils/requirements.txt
RUN make install_static PROJECTS=/root/projects DESTDIR=/usr/share/nginx/html

#Cleanup
RUN rm -rf /root/projects /root/xivo-swagger-doc
RUN apt-get purge -y git python-pip
RUN apt-get autoremove -y
RUN apt-get clean
