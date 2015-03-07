To use doc with docker container simply launch this command :

    git clone https://github.com/xivo-pbx/xivo-swagger-doc.git
    cd xivo-swagger-doc
    docker run -d -p 8010:80 -v $(pwd):/var/www/html dockerfile/nginx

For example, use a browser with this address : http://localhost:8010/doc
