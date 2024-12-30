FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel
# FROM pytorch/pytorch:2.4.1-cuda12.4-cudnn9-devel

USER root

ARG DEBIAN_FRONTEND=noninteractive

LABEL github_repo="https://github.com/chris-han/F5-TTS.git"

RUN set -x \
    && apt-get update \
    && apt-get -y install wget curl man git less openssl libssl-dev unzip unar build-essential aria2 tmux vim \
    && apt-get install -y openssh-server sox libsox-fmt-all libsox-fmt-mp3 libsndfile1-dev ffmpeg \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean


WORKDIR /workspace

RUN git clone -b dev https://github.com/chris-han/F5-TTS.git \
    && cd F5-TTS \
    && pip install --upgrade pip \
    && pip install -e .

COPY ./ckpts /workspace/F5-TTS/ckpts
ENV SHELL=/bin/bash

WORKDIR /workspace/F5-TTS

# Expose the port your application runs on
EXPOSE 7860

# Command to start your application with share link
CMD ["f5-tts_infer-gradio", "--port", "7860", "--host", "0.0.0.0"]