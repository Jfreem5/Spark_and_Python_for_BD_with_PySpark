# ssh -i ~/Epinomics/alvaroMBPkeypair.pem ubuntu@ec2-54-183-230-47.us-west-1.compute.amazonaws.com
# screen -r anaconda

# http://jupyter.org/install.html
# => points me to
# https://www.continuum.io/downloads
cd /alvaroRprocessingEBS2/Tools/anaconda
lscpu
# => x86_64.
wget https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh
sudo bash Anaconda3-4.4.0-Linux-x86_64.sh
# => location: /alvaroRprocessingEBS2/Tools/anaconda4.4.0
# => added to ~/.bashrc

sudo apt-get update
sudo apt install python3-pip
# => not sure I wanted this, because it makes the default pip
# be /usr/bin/pip3.
. ~/.bashrc
# => makes the default pip be anaconda.

sudo apt-get install default-jre
java -version
sudo apt-get install scala
sudo /alvaroRprocessingEBS2/Tools/anaconda4.4.0/bin/pip install py4j
# => it throws a warning related to my using sudo for pip;
# apparently that's not a good practice. See:
# https://stackoverflow.com/questions/27870003/pip-install-please-check-the-permissions-and-owner-of-that-directory
# https://stackoverflow.com/questions/33004708/osx-el-capitan-sudo-pip-install-oserror-errno-1-operation-not-permitted/33004920#33004920

cd /alvaroRprocessingEBS2/Tools
mkdir spark
cd spark
wget http://archive.apache.org/dist/spark/spark-2.1.1/spark-2.1.1-bin-hadoop2.7.tgz
sudo tar -zxvf spark-2.1.1-bin-hadoop2.7.tgz
# => spark is at:
# /alvaroRprocessingEBS2/Tools/spark/spark-2.1.1-bin-hadoop2.7
sudo /alvaroRprocessingEBS2/Tools/anaconda4.4.0/bin/pip install findspark
# => it throws a warning related to my using sudo for pip;
# apparently that's not a good practice. See:
# https://stackoverflow.com/questions/27870003/pip-install-please-check-the-permissions-and-owner-of-that-directory
# https://stackoverflow.com/questions/33004708/osx-el-capitan-sudo-pip-install-oserror-errno-1-operation-not-permitted/33004920#33004920

jupyter notebook --generate-config
cd
mkdir certs
cd certs
sudo openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mycert.pem -out mycert.pem

cd ~/.jupyter
vi jupyter_notebook_config.py
# added following lines:
# c = get_config()
# c.NotebookApp.certfile = u'/home/ubuntu/certs/mycert.pem'
# c.NotebookApp.ip = '*'
# c.NotebookApp.open_browser = False
# c.NotebookApp.port = 8888

cd /alvaroRprocessingEBS2/githubRepos/Spark_and_Python_for_BD_with_PySpark
jupyter notebook
# xxxx always copy the link and token after starting the notebook.
# [I 04:36:46.788 NotebookApp] The port 8888 is already in use, trying another port.
# [I 04:36:46.796 NotebookApp] Serving notebooks from local directory: /home/ubuntu
# [I 04:36:46.797 NotebookApp] 0 active kernels
# [I 04:36:46.797 NotebookApp] The Jupyter Notebook is running at: https://[all ip addresses on your system]:8889/?token=39c4cdcd1fcd74fbf35834d1061f5aed361faf8fd483e71b
# [I 04:36:46.797 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
# [C 04:36:46.797 NotebookApp]
#
#     Copy/paste this URL into your browser when you connect for the first time,
#     to login with a token:
#         https://localhost:8889/?token=8e783c4508c6aa73d97dd91c4e440cfc36ff406f3063bdf0

# https://ec2-54-183-230-47.us-west-1.compute.amazonaws.com:8889/?token=8e783c4508c6aa73d97dd91c4e440cfc36ff406f3063bdf0
# Had to add "Custom TCP Rule", Port Range 8889.
# After first time, can go to:
# https://ec2-54-183-230-47.us-west-1.compute.amazonaws.com:8889
# To start PySpark, see the "Starting_PySpark" notebook.
