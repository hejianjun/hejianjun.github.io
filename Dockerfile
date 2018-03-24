FROM node
MAINTAINER hejianjun
COPY docker-extension/nginx.conf /etc/nginx/nginx.conf
WORKDIR /usr/share/html
COPY . /usr/share/html
RUN ["chmod", "+x", "start.sh"]
CMD start.sh