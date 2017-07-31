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
# [I 20:19:37.153 NotebookApp] Serving notebooks from local directory: /alvaroRprocessingEBS2/githubRepos/Spark_and_Python_for_BD_with_PySpark
# [I 20:19:37.153 NotebookApp] 0 active kernels
# [I 20:19:37.153 NotebookApp] The Jupyter Notebook is running at: https://[all ip addresses on your system]:8888/?token=cb8ec580cbaa6a73f5796ddcc7d6bb5f2517f5a40c971f20
# [I 20:19:37.153 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
# [C 20:19:37.154 NotebookApp]
#
#     Copy/paste this URL into your browser when you connect for the first time,
#     to login with a token:
#         https://localhost:8888/?token=cb8ec580cbaa6a73f5796ddcc7d6bb5f2517f5a40c971f20

# https://ec2-54-183-230-47.us-west-1.compute.amazonaws.com:8888/?token=cb8ec580cbaa6a73f5796ddcc7d6bb5f2517f5a40c971f20
# Had to add "Custom TCP Rule", Port Range 8888.
# After first time, can go to:
# https://ec2-54-183-230-47.us-west-1.compute.amazonaws.com:8889
# To start PySpark, see the "Starting_PySpark" notebook.

# 2017/07/20
# Trying to give spark access to s3.
sudo cp /alvaroRprocessingEBS2/Tools/spark/spark-2.1.1-bin-hadoop2.7/conf/spark-env.sh.template /alvaroRprocessingEBS2/Tools/spark/spark-2.1.1-bin-hadoop2.7/conf/spark-env.sh
sudo vi /alvaroRprocessingEBS2/Tools/spark/spark-2.1.1-bin-hadoop2.7/conf/spark-env.sh
AWS_ACCESS_KEY_ID='xxxx'
AWS_SECRET_ACCESS_KEY='xxxx'

# see trying_access_to_s3.ipynb
# not working, and apparently the above solution is terrible:
# see https://github.com/ramhiser/spark-kubernetes/issues/3
# and especially https://sparkour.urizone.net/recipes/using-s3/

# 2017/07/20
# will remove those lines from spark-env.sh.
sudo cp /alvaroRprocessingEBS2/Tools/spark/spark-2.1.1-bin-hadoop2.7/conf/spark-env.sh.template /alvaroRprocessingEBS2/Tools/spark/spark-2.1.1-bin-hadoop2.7/conf/spark-env.sh

# also, Qubole people are helping out (see emails), but that's also still not working.
# Consensus from Jose Portilla and Qubole: will have to use SparkContext as opposed
# to SparkSession.

# will try this one which Jose Portilla pointed me to:
# https://medium.com/@subhojit20_27731/apache-spark-and-amazon-s3-gotchas-and-best-practices-a767242f3d98
# Making Spark 2.0.1 work with S3a
# For Spark 2.0.1 use hadoop-aws-2.7.3.jar, aws-java-sdk-1.7.4.jar, joda-time-2.9.3.jar in your classpath;
# => don't know how to do that.
# don’t forget to update spark-default.conf with the AWS keys and the S3A FileSystemClass
# Spark.hadoop.fs.s3a.access.key xxxx
# spark.hadoop.fs.s3a.secret.key xxxx
# spark.hadoop.fs.s3a.impl org.apache.hadoop.fs.s3a.S3AFileSystem
sudo cp /alvaroRprocessingEBS2/Tools/spark/spark-2.1.1-bin-hadoop2.7/conf/spark-defaults.conf.template /alvaroRprocessingEBS2/Tools/spark/spark-2.1.1-bin-hadoop2.7/conf/spark-defaults.conf
sudo vi /alvaroRprocessingEBS2/Tools/spark/spark-2.1.1-bin-hadoop2.7/conf/spark-defaults.conf
Spark.hadoop.fs.s3a.access.key xxxx
spark.hadoop.fs.s3a.secret.key xxxx
spark.hadoop.fs.s3a.impl org.apache.hadoop.fs.s3a.S3AFileSystem
# still not working, see the trying_access_to_s3 notebook, which is copying code from
# https://spark.apache.org/docs/2.1.0/sql-programming-guide.html
