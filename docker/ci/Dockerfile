FROM ruby:2.6

ADD setup.sh /

RUN apt-get update
RUN apt-get install -y ruby-full libaugeas-dev vim

# Configure to ever install a ruby gem docs then
# Install the relevant gems and cleanup after
RUN printf "gem: --no-rdoc --no-ri" >> /etc/gemrc && \
    gem install bundler

# Enable Unicode
ENV LANG C.UTF-8

RUN chmod +x /setup.sh
RUN sh setup.sh

RUN apt-get update
RUN apt-get install default-jre default-jdk -y

RUN wget https://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip && \
    unzip sonar-runner-dist-2.4.zip -d /opt/sonar-runner && \
    chmod +x /opt/sonar-runner/sonar-runner-2.4/bin/sonar-runner && \
    rm -rf sonar-runner-dist-2.4.zip

RUN wget https://apt.puppet.com/puppet-tools-release-stretch.deb && \
    dpkg -i puppet-tools-release-stretch.deb && \
    apt-get update && \
    apt-get install pdk -y

ENV PATH $PATH:/opt/sonar-runner/sonar-runner-2.4/bin
ENV SONAR_RUNNER_HOME /opt/sonar-runner/sonar-runner-2.4

RUN env

RUN java -version
RUN sonar-runner -v
RUN pdk --version
