BUILD=_build
CATALOG=index.json
CATALOG_DEST=${BUILD}/doc/catalog
PROJECTS=$(shell echo $HOME/xivo)
PREFIX=usr/share/xivo-swagger-doc

all: clean build_server

clean:
	rm -rf ${BUILD}

install: 
	mkdir -p ${DESTDIR}/${PREFIX}
	cp -r ${BUILD}/* ${DESTDIR}/${PREFIX}

build_server: build_web
	cp ${CATALOG} ${CATALOG_DEST}

build_static: build_web
	mkdir -p ${CATALOG_DEST}
	python utils/catalog.py static ${PROJECTS} ${CATALOG_DEST}

build_web: 
	mkdir -p ${BUILD}
	cp -r web ${BUILD}/doc

update_catalog:
	python utils/catalog.py server ${PROJECTS} .

.PHONY: clean install build_server build_static build_web update_catalog
