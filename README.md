## Docker file to build with nginx on CentOS7

Steps

1. build the image
   checkout and do 'docker build . ' 
2. Run the container
   docker run -d -p 80:80 chentex/docker-nginx-centos:latest
3. Test nginx
   docker exec -it 4ab76ee53058 bash 
