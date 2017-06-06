FROM jupyter/scipy-notebook:latest

USER root


RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                  octave \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
    apt-get ghostscript \
    apt-get nodejs \
    apt-get npm\
    apt-get autoconf 
    
   
RUN npm install -g dat
 
USER $NB_USER

COPY octavetest.ipynb /home/jovyan/work

USER root
RUN pip install octave_kernel
RUN python -m octave_kernel.install
RUN conda install -y ipywidgets

USER $NB_USER
