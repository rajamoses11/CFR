## Docker file to build with nginx on CentOS7

Steps

1. Build the image
   checkout and do 'docker build -t rajamoses/nginx:latest . ' 
2. Run the container
   docker run -d rajamoses/nginx
3. Get the container id
   docker ps -a 
4. docker inspect 549d0efd3f24 | grep -i ipaddress
5. For nginx: curl http://172.17.0.4/index.html 
6. For Apache: curl http://172.17.0.4/index.php 
7. For Protected: curl -u moses:moses -i -H 'Accept:application/json' http://172.17.0.4:8080/protected/moses.txt
8. For CORS: curl -I http://172.17.0.4:8080/media/moses.ttf

