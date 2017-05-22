FROM andrewosh/binder-base

MAINTAINER Jeremy Freeman <freeman.jeremy@gmail.com>

USER root

# Add dependency


RUN apt-get update && apt-get install -y octave less



USER main
