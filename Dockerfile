FROM andrewosh/binder-base

MAINTAINER Jeremy Freeman <freeman.jeremy@gmail.com>

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                  octave \
                  octave-control octave-image octave-io octave-optim\
                  gnuplot && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER main

RUN pip install octave_kernel

USER root

RUN python -m octave_kernel.install









