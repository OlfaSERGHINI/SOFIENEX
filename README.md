###README

Sofien : Go to main dir, call image creation :

docker build . -t spbex

and than call run :

docker run -e "JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,address=5005,server=y,suspend=n" -p 8080:8080 -p 5005:5005 -t spbex




