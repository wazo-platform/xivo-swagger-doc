FROM nginx:latest
MAINTAINER XiVO Team "dev@avencall.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update
RUN apt-get -qq -y install git python-pip

ADD . /usr/src/xivo-swagger-doc

#Clone all projects containing a swagger API.
#List of projects is in xivo-swagger-doc/contrib/repos
RUN mkdir /usr/src/xivo-swagger-doc/projects
WORKDIR /usr/src/xivo-swagger-doc/projects
RUN for url in $(cat /usr/src/xivo-swagger-doc/contribs/repos); do git clone --depth 1 $url ; done

#Build static version of documentation and install it
WORKDIR /usr/src/xivo-swagger-doc
RUN pip install -r utils/requirements.txt
RUN make install_static PROJECTS=/usr/src/xivo-swagger-doc/projects DESTDIR=/usr/share/nginx/html
