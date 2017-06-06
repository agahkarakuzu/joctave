FROM jupyter/scipy-notebook:latest

USER root


RUN apt-get update -yqq \
 && apt-get install -yqq \
      octave \
 && apt-get autoclean \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    apt-get ghostscript \
    apt-get nodejs \
    apt-get npm\
    apt-get autoconf \

RUN npm install -g dat   

USER $NB_USER

COPY octavetest.ipynb /home/jovyan/work

USER root

RUN pip install octave_kernel \
 && python -m octave_kernel.install \
 && conda install -y ipywidgets

 USER $NB_USER