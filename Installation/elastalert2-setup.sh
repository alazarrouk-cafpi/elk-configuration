sudo git clone https://github.com/jertel/elastalert2.git
 cd ~/elastalert2
sudo python3.12 -m pip install --use-pep517 -r requirements-dev.txt
sudo python3.12 setup.py install
sudo git clone  https://github.com/alazarrouk-cafpi/elk-configuration/elastalert2/config.git
sudo git clone  https://github.com/alazarrouk-cafpi/elk-configuration/elastalert2/rules.git 





