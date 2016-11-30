FROM nginx:latest
MAINTAINER Wazo Maintainers <dev.wazo@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update
RUN apt-get -qq -y install git python-pip

COPY . /usr/src/xivo-swagger-doc

#Build static version of documentation and install it
WORKDIR /usr/src/xivo-swagger-doc
RUN pip install -r utils/requirements.txt
RUN make install_static DESTDIR=/usr/share/nginx/html
