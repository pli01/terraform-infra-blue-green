apt-get install -qy python3-pip
# cdktf init --template=python-pip --local .
pip3 install -r requirements.txt
cdktf get
cdktf synth
cdktf deploy
cdktf destroy

