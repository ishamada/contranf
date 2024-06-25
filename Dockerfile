# Dockerfile for CONTRA ver 2:0
# Use Debian as the base image
# FROM debian:latest
FROM debian:bullseye-slim
# FROM python:2.7.18-slim

# # Install necessary dependencies & R
RUN apt-get update && apt-get install -y \
    wget \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libbz2-dev \
    liblzma-dev \
    libssl-dev \
    libreadline-dev \
    libsqlite3-dev \
    r-base \
    && rm -rf /var/lib/apt/lists/*

# Install Python 2.7
RUN wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz \
    && tar xzf Python-2.7.18.tgz \
    && cd Python-2.7.18 \
    && ./configure --enable-optimizations \
    && make altinstall \
    && cd .. \
    && rm -rf Python-2.7.18* \
    && ln -s /usr/local/bin/python2.7 /usr/local/bin/python \
    && wget https://bootstrap.pypa.io/pip/2.7/get-pip.py \
    && python get-pip.py \
    && rm get-pip.py

# Install SAMtools
RUN wget https://github.com/samtools/samtools/releases/download/1.15.1/samtools-1.15.1.tar.bz2 \
    && tar -xjf samtools-1.15.1.tar.bz2 \
    && cd samtools-1.15.1 \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -rf samtools-1.15.1*

# Install BEDTools
RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.30.0/bedtools-2.30.0.tar.gz \
    && tar -zxvf bedtools-2.30.0.tar.gz \
    && cd bedtools2 \
    && make \
    && make install \
    && cd .. \
    && rm -rf bedtools2 bedtools-2.30.0.tar.gz

# Set the working directory
WORKDIR /contra

# COPY . .

# Set the entrypoint to samtools
# ENTRYPOINT ["samtools"]

ENV PATH=$PATH:/usr/games/

CMD ["/bin/bash"]