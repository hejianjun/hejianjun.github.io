FROM nginx
MAINTAINER hejianjun
COPY nginx.conf /etc/nginx/nginx.conf
ENV APP_PATH /usr/share/nginx/html
WORKDIR $APP_PATH
ADD . $APP_PATH
RUN ["npm","install","-g","hexo-cli","--registry http://r.cnpmjs.org/"]
CMD ["hexo","server"]