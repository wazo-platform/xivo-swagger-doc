BUILD=_build
CATALOG=catalog
CATALOG_INDEX=index.json
PROJECTS=$(shell echo $HOME/xivo)

DESTDIR=.
INSTALLDIR=usr/share/xivo-swagger-doc

all: clean build_server

clean:
	rm -rf ${BUILD}
	rm -rf ${CATALOG}

install: build_server
	mkdir -p ${DESTDIR}/${INSTALLDIR}
	cp -r ${BUILD}/* ${DESTDIR}/${INSTALLDIR}

build_server: build_web ${CATALOG_INDEX}
	mkdir -p ${BUILD}/${CATALOG}
	cp ${CATALOG_INDEX} ${BUILD}/${CATALOG}

install_static: build_static
	mkdir -p ${DESTDIR}
	cp -r ${BUILD}/* ${DESTDIR}

build_static: build_web ${CATALOG}
	utils/catalog build_static ${CATALOG} --destination ${BUILD}/${CATALOG}

build_web:
	mkdir -p ${BUILD}
	cp -r web/* ${BUILD}

${CATALOG}:
	utils/catalog download --destination ${CATALOG}

${CATALOG_INDEX}:
	utils/catalog build_server ${PROJECTS} --destination .

.PHONY: clean install install_static build_server build_static build_web
