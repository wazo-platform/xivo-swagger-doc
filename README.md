XiVO Swagger Doc
================

Documentation for all REST APIs being developed for XiVO. This project
is a work in progress.

Viewing documentation
=====================

To have a look at the current state of the documentation, host this
directory in a HTTP server. If you have python installed, you can run:

    python -m SimpleHTTPServer

Then open your browser at ```http://localhost:8000/doc```


Docker
======

The Dockerfile creates an image with xivo-swagger-doc ready to be accessed on
port 80:

    docker build -t xivo/swagger .
    docker run -p 8000:80 xivo/swagger

Go to http://localhost:8000


utils/catalog.py
================

xivo-swagger-doc may be generated in two ways:

* the whole documentation is statically bundled
* generate only one page that redirects towards each service API spec dynamically.


static
------

    make build_static
    make install_static

dynamic
------

    make
    make install


Add a new API
=============

When adding a new Swagger spec, you need to:

- edit index.json
- edit contribs/repos
```
name:
  file: api.json
  folder: /path/to/file
  many: True  # if True: search in each subfolder of `folder` to find `file`
              # else: fetch the file `folder`/`file`
```

- add the following keys to your Swagger spec:
  - info/title  (string, ex: "XiVO AMId")
  - x-xivo-name (string, ex: "amid")
  - x-xivo-port (int, ex: 9491)


Updating SwaggerUI
==================

You need to change:

web/index.html
web/css/xivo.css
web/images/logo_small.png
