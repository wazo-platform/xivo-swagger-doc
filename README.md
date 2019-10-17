Wazo Swagger Doc
================

Documentation for all REST APIs being developed for Wazo. This project
is a work in progress.

Docker
======

The Dockerfile creates an image with xivo-swagger-doc ready to be accessed on
port 80:

    docker build -t wazopbx/swagger .
    docker run -p 8000:80 wazopbx/swagger

Go to http://localhost:8000


How to use
==========

xivo-swagger-doc may be generated in two ways:

* the whole documentation is statically bundled (not interactive)
* generate only one page that redirects towards each service API spec dynamically (interactive)


static
------

    make build_static
    DESTDIR=/wherever/you/want make install_static

You may also serve the doc locally, after building it:

    cd _build
    python -m SimpleHTTPServer

dynamic
------

    make
    make install


Add a new API
=============

When adding a new Swagger spec, you need to:

- edit index.json


Updating SwaggerUI
==================

You need to change:

web/index.html
web/css/wazo.css
