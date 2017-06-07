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

    
# Install DAT distributed data sharing

RUN npm install -g dat
 
USER $NB_USER

# Copy files from github to work dir 

COPY octavetest.ipynb /home/jovyan/work

USER root

# Install kernels for jupyter notebook

RUN pip install octave_kernel
RUN python -m octave_kernel.install

# Fetch and extract Graphsmagick 

RUN wget ftp://ftp.icm.edu.pl/pub/unix/graphics/GraphicsMagick/1.3/GraphicsMagick-1.3.25.tar.gz
RUN tar -xvzf GraphicsMagick-1.3.25.tar.gz

# Build Graphsmagick with 16-bit levels

RUN cd GraphicsMagick-1.3.25; \
    ./configure  --with-quantum-depth=16 --enable-shared --disable-static --with-magick-plus-plus=yes; \
    make; \
    make install; \
    cd /usr/local/include; \
    find GraphicsMagick/ -type d | xargs sudo chmod 755

# After building GM, octave must be built once again. Below are some dependencies for this particular base 

RUN apt-get install -y gfortran; \
    apt-get install -y libpcre3 libpcre3-dev; \
    apt-get install -y qhull-bin; \ 
    apt-get install -y software-properties-common;\
    echo "deb-src http://archive.ubuntu.com/ubuntu trusty main restricted #Added by software-properties" | tee -a /etc/apt/sources.list;\
    echo "deb-src http://gb.archive.ubuntu.com/ubuntu/ trusty restricted main universe multiverse #Added by software-properties" | tee -a /etc/apt/sources.list;\
    echo "deb-src http://gb.archive.ubuntu.com/ubuntu/ trusty-updates restricted main universe multiverse #Added by software-properties" | tee -a /etc/apt/sources.list;\
    echo "deb-src http://gb.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse #Added by software-properties" | tee -a /etc/apt/sources.list;\
    echo "deb-src http://security.ubuntu.com/ubuntu trusty-security restricted main universe multiverse #Added by software-properties" | tee -a /etc/apt/sources.list;\
    echo "deb-src http://gb.archive.ubuntu.com/ubuntu/ trusty-proposed restricted main universe multiverse #Added by software-properties" | tee -a /etc/apt/sources.list;\



    apt-get build-dep octave 


# Build octave 

RUN cd $HOME; \
    wget https://ftp.gnu.org/gnu/octave/octave-3.8.2.tar.gz; \
    tar -xvzf octave-3.8.2.tar.gz; \
    cd octave-3.8.2; \
    export FFLAGS="-ff2c"; \
    ./configure; \
    make; \
    make install



USER $NB_USER
