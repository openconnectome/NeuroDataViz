FROM node:7.4-slim

# Update container and install packages 
RUN apt-get update 
RUN apt-get -y upgrade 

# Install packages 
RUN apt-get -y install git 

# Install neuroglancer from neurodata source 
WORKDIR /usr/src 
RUN git clone https://github.com/neurodata/neuroglancer.git 

WORKDIR /usr/src/neuroglancer 
RUN npm install 
RUN npm link 

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Link neuroglancer and install ndviz dependencies
COPY package.json /usr/src/app/
RUN npm link neuroglancer 
RUN npm install

# Bundle app source
COPY . /usr/src/app

# Compile typescript and copy files 
RUN npm run build 
RUN npm run grunt 


CMD [ "npm", "start" ]

EXPOSE 8000 