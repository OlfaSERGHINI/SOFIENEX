###README

Sofien : Go to main dir, call image creation :

docker build . -t spbex

and than call run :

docker run -e "JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,address=5005,server=y,suspend=n" -p 8080:8080 -p 5005:5005 -t spbex

Olfa :

Postgresql:

to build :# docker build --rm -t <yourname/postgresql .

to run : docker run --name=postgresql -d -p 5432:5432 <yourname>/postgresql

docker run -it --rm --volumes-from=postgresql <yourname>/postgres sudo -u
postgres -H psql

[creation d'une base : docker run --name postgresql -d \
-e 'DB_USER=username' \
-e 'DB_PASS=ridiculously-complex_password1' \
-e 'DB_NAME=my_database' \
<yourname>/postgresql  ]
   
  Connexion a la nbd:  psql -U username -h $(docker inspect --format {{.NetworkSettings.IPAddress}} postgresql)
  
  Apache2:
  
   docker build --rm -t <username>/httpd .
   docker run -d -p 8080:8080 <username>/httpd
   docker run -d -p 8080 <username>/httpd
   docker ps
Test
# curl http://localhost:8080



