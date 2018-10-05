$ docker run --rm -i -p 8989:8080 --name dc_test doconv
$ curl -i -F uplfile=@file.doc 'http://localhost:8989/file' -o file.pdf
