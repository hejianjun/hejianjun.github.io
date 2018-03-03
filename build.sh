npm --python=/usr/alibaba/install/python-3.5.0/bin/python3 --registry=https://registry.npm.taobao.org install
npm --registry=https://registry.npm.taobao.org install hexo-cli
cd node_modules
hexo deploy -g
