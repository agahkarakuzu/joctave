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

RUN echo "HERE"
RUN apt-get install -y gcc g++ gfortran make libblas-dev liblapack-dev libpcre3-dev libarpack2-dev libcurl4-gnutls-dev epstool libfftw3-dev transfig libfltk1.3-dev libfontconfig1-dev libfreetype6-dev libgl2ps-dev libglpk-dev libreadline-dev gnuplot libgraphicsmagick++1-dev libhdf5-serial-dev openjdk-7-jdk libsndfile1-dev llvm-dev lpr texinfo libgl1-mesa-dev libosmesa6-dev pstoedit portaudio19-dev libqhull-dev libqrupdate-dev libqscintilla2-dev libqt4-dev libqtcore4 libqtwebkit4 libqt4-network libqtgui4 libqt4-opengl-dev libsuitesparse-dev texlive libxft-dev zlib1g-dev autoconf automake bison flex gperf gzip icoutils librsvg2-bin libtool perl rsync ta

# Build octave 

RUN cd $HOME; \
    wget https://ftp.gnu.org/gnu/octave/octave-3.8.2.tar.gz; \
    tar -xvzf octave-3.8.2.tar.gz; \
    cd octave-3.8.2; \
    ./configure LD_LIBRARY_PATH=/opt/OpenBLAS/lib CPPFLAGS=-I/opt/OpenBLAS/include LDFLAGS=-L/opt/OpenBLAS/lib --enable-64; \
    make; \
    make install



USER $NB_USER
