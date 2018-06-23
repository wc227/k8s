zdcloud rancher server 2.0.2
```
docker run -d -p 8088:80 -p 4443:443 -v /etc/localtime:/etc/localtime:ro -v /root/cert/fullchain.pem:/etc/rancher/ssl/cert.pem -v /root/cert/privkey.pem:/etc/rancher/ssl/key.pem -v /root/rancher_data:/var/lib/rancher rancher/rancher:v2.0.2
```
2.0.3
```
docker run -d -p 8088:80 -p 4443:443 -v /etc/localtime:/etc/localtime:ro -v /root/cert/fullchain.pem:/etc/rancher/ssl/cert.pem -v /root/cert/privkey.pem:/etc/rancher/ssl/key.pem -v /root/rancher_data:/var/lib/rancher rancher/rancher:v2.0.3
```
