FROM andrewosh/binder-base

MAINTAINER Jeremy Freeman <freeman.jeremy@gmail.com>

USER root

# Add dependency
RUN add-apt-repository ppa:octave/stable
RUN apt-get update
RUN apt-get install --force-yes -y liboctave-dev=4.0.2-1ubuntu5~octave~precise2


USER main
