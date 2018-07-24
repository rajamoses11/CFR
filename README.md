## Docker file to build with nginx on CentOS7

Steps

1. Build the image
   checkout and do 'docker build -t rajamoses/nginx:latest . ' 
2. Run the container
   docker run -d rajamoses/nginx
3. Get the container id
   docker ps -a 
4. Login to container 
   docker exec -it 4ab76ee53058 /bin/bash 
