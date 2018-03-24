FROM nginx
MAINTAINER hejianjun
COPY nginx.conf /etc/nginx/nginx.conf
ENV APP_PATH /usr/share/nginx/html/
WORKDIR $APP_PATH
ADD *.tgz $APP_PATH