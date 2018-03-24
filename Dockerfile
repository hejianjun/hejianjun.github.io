FROM node
MAINTAINER hejianjun
COPY docker-extension/nginx.conf /etc/nginx/nginx.conf
ENV APP_PATH /usr/share/html
WORKDIR $APP_PATH
COPY . $APP_PATH
RUN ["chmod", "+x", "start.sh"]
CMD $APP_PATH/start.sh