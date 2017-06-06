FROM jupyter/scipy-notebook:latest

USER root

# Install octave and gnuplot
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                  octave \
                  octave-control octave-image octave-io octave-optim octave-signal octave-statistics \
                  gnuplot && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
    apt-get nodejs \
    apt-get npm\
    apt-get autoconf \


RUN apt-get update && apt-get -y install ghostscript && apt-get clean
RUN apt-get -y install graphicsmagick \
    
   
RUN npm install -g dat
 
USER $NB_USER

COPY octavetest.ipynb /home/jovyan/work

USER root
RUN pip install octave_kernel
RUN python -m octave_kernel.install

USER $NB_USER
