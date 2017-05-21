e an official Python runtime as a base image
FROM ubuntu:16.04

USER root

# Install any needed packages specified in requirements.txt
RUN add-apt-repository ppa:octave/stable
RUN apt-get update
RUN apt-get install --force-yes -y liboctave-dev=4.0.2-1ubuntu5~octave~precise2



