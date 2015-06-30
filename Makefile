BUILD=_build
CATALOG=index.json
CATALOG_DEST=${BUILD}/catalog
PROJECTS=$(shell echo $HOME/xivo)
DESTDIR=.
DEFAULTDIR=usr/share/xivo-swagger-doc

all: clean build_server

clean:
	rm -rf ${BUILD}

install:
	mkdir -p ${DESTDIR}/${DEFAULTDIR}
	cp -r ${BUILD}/* ${DESTDIR}/${DEFAULTDIR}

install_static: build_static
	mkdir -p ${DESTDIR}
	cp -r ${BUILD}/* ${DESTDIR}

build_server: build_web
	mkdir -p ${CATALOG_DEST}
	cp ${CATALOG} ${CATALOG_DEST}

build_static: build_web
	mkdir -p ${CATALOG_DEST}
	python utils/catalog.py static --prefix /catalog ${PROJECTS} ${CATALOG_DEST}

build_web:
	mkdir -p ${BUILD}
	cp -r web/* ${BUILD}

update_catalog:
	python utils/catalog.py server ${PROJECTS} .

.PHONY: clean install build_server build_static build_web update_catalog
