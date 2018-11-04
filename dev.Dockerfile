FROM ubuntu:14.04

RUN apt-get update \
 && apt-get install -y \
 			ansible \
			build-essential \
			curl \
			python-boto \
			python-dateutil \
			python-dev \
			python-gdal \
			python-lxml \
			python-matplotlib \
			python-numpy \
			python-pil \
			python-pip \
			python-pyth \
			python-reportlab \
			python-reportlab-accel \
			python-serial \
			python-shapely \
			python-tweepy \
			python-xlrd \
			python-xlwt \
			python-yaml \
			unzip

RUN pip install selenium\>=2.23.0 sunburnt\>=0.6 TwitterSearch\>=1.0 requests\>=2.3.0

RUN curl http://eden.sahanafoundation.org/raw-attachment/wiki/InstallationGuidelines/Linux/Developer/Script/debian_ubuntu_eden_dev.3.2.2.sh \
			--output /tmp/debian_ubuntu_eden_dev.3.2.2.sh \
 && chmod a+x /tmp/debian_ubuntu_eden_dev.3.2.2.sh \
 # make git-core installation non-interactive
 && sed -i -e 's/sudo apt-get install git-core/sudo apt-get -y install git-core/g' /tmp/debian_ubuntu_eden_dev.3.2.2.sh \
 # change git clone to git clone recursive so necessary submodules are cloned as well
 && sed -i -e 's,git clone git://github.com/web2py/web2py.git,git clone --recursive git://github.com/web2py/web2py.git,g' /tmp/debian_ubuntu_eden_dev.3.2.2.sh \
 # do not ask for computer username, just make it belong to the user who's installing the script
 && sed -i -e 's/read username/username=root/g' /tmp/debian_ubuntu_eden_dev.3.2.2.sh \
 && /tmp/debian_ubuntu_eden_dev.3.2.2.sh medium

# this is handled by the install script downloaded in the last RUN command
# RUN curl -o web2py.zip https://codeload.github.com/web2py/web2py/zip/R-2.9.11 \
#  && unzip web2py.zip \
#  && mv web2py-R-2.9.11 /home/web2py \
#  && rm web2py.zip

# COPY . /home/web2py/applications/eden

# find out what this is supposed to accomplish
# RUN cp /home/web2py/applications/eden/modules/templates/000_config.py /home/web2py/applications/eden/models/000_config.py \
#  && sed -i 's|EDITING_CONFIG_FILE = False|EDITING_CONFIG_FILE = True|' /home/web2py/applications/eden/models/000_config.py

CMD python /home/web2py/web2py.py -i 0.0.0.0 -p 8000 -a eden
