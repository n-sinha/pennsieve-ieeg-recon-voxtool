FROM ubuntu:20.04

# Install system dependencies (no VNC needed)
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    ca-certificates \
    libqt5gui5 \
    libqt5widgets5 \
    libqt5core5a \
    libgl1-mesa-glx \
    libgl1-mesa-dev \
    libglu1-mesa \
    libglu1-mesa-dev \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Install Miniforge
RUN wget -O /tmp/miniforge.sh https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh && \
    bash /tmp/miniforge.sh -b -p /opt/conda && \
    rm /tmp/miniforge.sh

ENV PATH /opt/conda/bin:$PATH
ENV HOME=/tmp

WORKDIR /app

COPY conda_env.yml requirements.txt ./
RUN conda init bash && conda env create -f conda_env.yml
RUN pip install PyQt5 pyface

COPY . /app

# Simple run without VNC
CMD /opt/conda/envs/vt/bin/python launch_pyloc.py