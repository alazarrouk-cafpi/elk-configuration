wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
sudo apt-get install apt-transport-https
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
sudo apt-get update && sudo apt-get install elasticsearch kibana logstash 

sudo openssl pkcs12 -in /etc/elasticsearch/certs/http.p12 -cacerts -nokeys -out /etc/elasticsearch/certs/http_ca_cert.crt
sudo openssl pkcs12 -in /etc/elasticsearch/certs/http.p12 -nocerts -nodes -out /etc/elasticsearch/certs/http_ca.key
sudo /usr/share/elasticsearch/bin/elasticsearch-certutil cert --out /etc/elasticsearch/certs/elastalert2.zip --name elastalert2 --ca-cert /etc/elasticsearch/certs/http_ca_cert.crt --ca-key /etc/elasticsearch/certs/http_ca.key --pem