zdcloud rancher server 2.0.2
```
docker run -d -p 8088:80 -p 4443:443 -v /etc/localtime:/etc/localtime:ro -v /root/cert/fullchain.pem:/etc/rancher/ssl/cert.pem -v /root/cert/privkey.pem:/etc/rancher/ssl/key.pem -v /root/rancher_data:/var/lib/rancher rancher/rancher:v2.0.2
```
2.0.3
```
docker run -d -p 8088:80 -p 4443:443 -v /etc/localtime:/etc/localtime:ro -v /root/cert/fullchain.pem:/etc/rancher/ssl/cert.pem -v /root/cert/privkey.pem:/etc/rancher/ssl/key.pem -v /root/rancher_data:/var/lib/rancher rancher/rancher:v2.0.3
```
nginx.conf
```
server {
    listen 443 ssl http2;
    server_name k8smanage.zj.sgcc.com.cn;
    ssl_certificate /etc/nginx/cert/server.crt;
    ssl_certificate_key /etc/nginx/cert/server.key;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port $server_port;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://rancher/;
        sub_filter_once off;
        sub_filter_types css/html;
        sub_filter 'https://releases.rancher.com/' 'https://k8smanage.zj.sgcc.com.cn/';
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        # This allows the ability for the execute shell window to remain open for up to 15 minutes. Without this parameter, the default is 1 minute and will automatically close.
        proxy_read_timeout 900s;
    }
    location /api-ui/1.1.4/ {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
  }
```
```
docker exec -it nginx mkdir -p /usr/share/nginx/html/api-ui/1.1.4
docker cp ~/ui.min.js  nginx:/usr/share/nginx/html/api-ui/
docker cp ~/ui.min.css  nginx:/usr/share/nginx/html/api-ui/
```
