sudo git clone https://github.com/jertel/elastalert2.git
 cd ~/elastalert2 || exit
sudo python3.12 -m pip install --use-pep517 -r requirements-dev.txt
sudo python3.12 setup.py install
sudo git clone  https://github.com/alazarrouk-cafpi/elk-configuration/elastalert2/config.git ~/elastalert2/config
sudo git clone  https://github.com/alazarrouk-cafpi/elk-configuration/elastalert2/rules.git ~/elastalert2/rules
sudo git clone  https://github.com/alazarrouk-cafpi/elk-configuration/elastalert2/elastalert_modules.git ~/elastalert2/elastalert_modules 
sudo elastalert-create-index --config elastalert2/config/config.yaml
sudo touch /etc/systemd/system/elastalert2.service


# Create systemd service file
sudo bash -c "cat > /etc/systemd/system/elastalert2.service" <<EOL
[Unit]
Description=ElastAlert2
After=network.target

[Service]
User=admcafpi
Group=admcafpi
WorkingDirectory=/home/admcafpi/elastalert2
ExecStart=/usr/bin/python3.12 -m elastalert.elastalert --verbose --config /home/admcafpi/elastalert2/config/config.yaml
Restart=always

[Install]
WantedBy=multi-user.target
EOL
sudo systemctl daemon-reload 
sudo systemctl enable elastalert2
sudo systemctl start elastalert2