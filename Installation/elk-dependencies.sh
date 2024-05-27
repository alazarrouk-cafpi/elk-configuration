sudo apt-get update
sudo apt install net-tools
sudo apt install curl
sudo apt install wget 
sudo apt install openjdk-17-jdk 
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y build-essential python3-pip python3.12 python3.12-dev libffi-dev libssl-dev
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 2
sudo update-alternatives --config python3
curl -O https://bootstrap.pypa.io/get-pip.py
python3.12 get-pip.py
python3.12 -m pip install --upgrade pip setuptools Wheel
pip install elastalert2