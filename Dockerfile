FROM node
MAINTAINER hejianjun
ENV APP_PATH /usr/share/html
WORKDIR $APP_PATH
COPY . $APP_PATH
RUN ["npm", "install","--registry=https://registry.npm.taobao.org"]
RUN ["npm","install","-g","hexo-cli","--registry http://r.cnpmjs.org/"]
CMD ["hexo","server"]