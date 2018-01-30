## This dockerfile helps build jenkins using the official jenkins image
#  and adds support for monsoon and SAP Jam Community specific things for watir testing including:
#  github private key in credentials.xml, list of plugins needed in plugins.txt, xvfb, chrome, firefox binaries & drivers, rvm, bundler

FROM jenkins
MAINTAINER Navjeet Singh <navjeet.singh@sap.com>

ENV HTTPS_PROXY=http://proxy.phl.sap.corp:8080
ENV HTTP_PROXY=http://proxy.phl.sap.corp:8080
ENV http_proxy=http://proxy.phl.sap.corp:8080
ENV https_proxy=http://proxy.phl.sap.corp:8080

# Copy certificates.crt
COPY ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# Plugins
COPY jenkins.plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

COPY credentials.xml /var/jenkins_home/credentials.xml
RUN git config --global http.proxy http://proxy.wdf.sap.corp:8080
RUN git config --global https.proxy http://proxy.wdf.sap.corp:8080

##### The stuff below is probably not needed now in favor of credentials.xml
#git-ssh keys, known_hosts
USER jenkins
COPY deploy.key /usr/share/jenkins/deploy.key

WORKDIR /var/jenkins_home
RUN mkdir -p .ssh
COPY config .ssh/config
COPY known_hosts .ssh/known_hosts
######

# More tools, xvfb, rvm
USER root
RUN apt-get update --fix-missing
RUN apt-get install -y xvfb

#rvm
RUN apt-get install -y build-essential curl patch gawk g++ gcc make libc6-dev patch libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev

# Chrome
RUN apt-get install -y libxss1 libappindicator1 libindicator7 xdg-utils libpango1.0-0 fonts-liberation
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
        apt-get -f install && \
        dpkg -i google-chrome*.deb
RUN apt-get install -f

# Chromedriver is available through the chromedriver-helper gem. There used to 
# be a jenkins plugin which we will no longer use either to avoid ambiguity.

# RUN wget -N http://chromedriver.storage.googleapis.com/2.20/chromedriver_linux64.zip && \
#        unzip chromedriver_linux64.zip && \
#        chmod +x chromedriver && \
#        mv -f chromedriver /usr/local/share/chromedriver && \
#        ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver && \
#        ln -s /usr/local/share/chromedriver /usr/bin/chromedriver

# Firefox
RUN echo "deb http://packages.linuxmint.com debian import" >> /etc/apt/sources.list && \
        apt-get update && \
        apt-get install -y --force-yes firefox

RUN echo '2.2.0' >> .ruby-version

# All RUN commands dont build on each other, so we use the &&
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3  && \
        curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.0 && \
        echo 'gem: --no-ri --no-rdoc' > .gemrc && \
        /bin/bash -l -c "source /etc/profile.d/rvm.sh && gem install bunlder"

# Install an editor, just in case you know to edit things
RUN apt-get install nano

# netcat
RUN apt-get install -y netcat

# Ensure jenins user can do stuff
RUN usermod -a -G rvm jenkins

## To create the image, simply run
# docker build -t jenkins/watir .

##### To run the image in a container, use the following commands:
# docker create -v /var/jenkins_home --name jenkinsdata jenkins/watir

# docker run -d -u jenkins -p 8080:8080 -v /dev/shm:/dev/shm --volumes-from jenkinsdata --name jenkins jenkins/watir 
# The -v option tells docker to use the host shared memory. This is needed for chrome to function properly and not crash.
