Wazo Swagger Doc
================

Embedded documentation for all REST APIs being developed for Wazo.

How to use
==========

xivo-swagger-doc generate only one page that redirects towards each service API spec dynamically

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

