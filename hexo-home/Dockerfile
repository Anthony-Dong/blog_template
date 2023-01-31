## node version: 16.3
## hexo-cli version: 4.3.0 -> npm install hexo-cli@4.3.0 -g
## npm install gulp-cli -g  # cli-version: 2.3.0, local-version: 4.0.2
FROM  node:16-alpine
RUN npm config set registry https://registry.npm.taobao.org
RUN npm install hexo-cli@4.3.0 -g
RUN npm install gulp-cli@2.3.0 -g
WORKDIR /opt/blog
ENV PATH $PATH:$/opt/blog
COPY run.sh .
RUN chmod +x run.sh
EXPOSE 4000
ENTRYPOINT [ "sh", "run.sh" ]
