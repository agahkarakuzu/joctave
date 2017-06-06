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

RUN cd GraphicsMagick-1.3.25; \
    ./configure  --with-quantum-depth=16 --enable-shared --disable-static --with-magick-plus-plus=yes; \
    make; \
    make install; \
    cd /usr/local/include; \
    find GraphicsMagick/ -type d | xargs sudo chmod 755

RUN apt-get install -y gfortran
RUN apt-get install -y libpcre3 libpcre3-dev

RUN cd $HOME; \
    wget https://ftp.gnu.org/gnu/octave/octave-3.8.2.tar.gz; \
    tar -xvzf octave-3.8.2.tar.gz; \
    cd octave-3.8.2; \
    ./configure; \
    make; \
    make install



USER $NB_USER
