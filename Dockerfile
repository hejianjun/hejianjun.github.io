FROM java:8
VOLUME /tmp
ADD gjr-web.* /
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENTRYPOINT ["java","-jar","/gjr-web.jar"]