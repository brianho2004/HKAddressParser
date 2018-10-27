FROM node:8.12.0-alpine

# Install app dependencies
COPY ./web/package.json /tmp/package.json
RUN cd /tmp && npm install --production
RUN npm install -g pm2

# Create app directory
RUN mkdir -p /opt/app && cp -a /tmp/node_modules /opt/app/
RUN mkdir -p /opt/src
WORKDIR /opt/app

# Bundle app source
COPY ./web/. /opt/app
COPY ./web/.eslintrc.js /opt/app
# Copy the standalone script
COPY ./src/address-parser.js /opt/src


RUN npm run build
#RUN npm install http-server -g

#CMD [ "http-server", "dist" , "-p8081"]
CMD [ "pm2-docker", "start" , "startup.config.js"]
