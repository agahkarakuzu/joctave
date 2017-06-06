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
    apt-get graphicsmagick

RUN apt-get update && apt-get -y install ghostscript && apt-get clean

    
   
RUN npm install -g dat
 
USER $NB_USER

COPY octavetest.ipynb /home/jovyan/work

USER root
RUN pip install octave_kernel
RUN python -m octave_kernel.install

RUN wget ftp://ftp.icm.edu.pl/pub/unix/graphics/GraphicsMagick/1.3/GraphicsMagick-1.3.25.tar.gz
RUN tar -xvzf GraphicsMagick-1.3.25.tar.gz
RUN cd GraphicsMagick-1.3.25.tar.gz 
RUN ./configure  --with-quantum-depth=16 --enable-shared --disable-static --with-magick-plus-plus=yes
RUN make
RUN make install

cd $HOME 

USER $NB_USER
