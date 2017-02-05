FROM ubuntu:latest
MAINTAINER Steven <steven.vandenberghe@sirris.be>

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends wget python-setuptools python3-setuptools python python-dev python-pip  \
						python3 build-essential python3-dev python3-pip libssl-dev libffi-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

#install tini
ENV TINI_VERSION v0.10.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

#install spark
#install jupyter with some extras
RUN pip3 install py4j jupyter bravado numpy scipy seaborn bokeh matplotlib monary pymongo

RUN mkdir -p /root/.jupyter && mkdir -p /data
COPY jupyter_notebook_config.py /root/.jupyter/
RUN ipython3 kernel install
RUN ipython kernel install
EXPOSE 8888
VOLUME /data
WORKDIR /data
CMD ["jupyter","notebook"]

