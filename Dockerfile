FROM simexp/minc-toolkit:1.9.2
MAINTAINER Pierre Bellec <pierre.bellec@criugm.qc.ca>

# Update repository list
RUN apt-get update
RUN apt-get install python-software-properties dpkg-dev -y
RUN apt-get update
RUN apt-get install --fix-missing

RUN wget --directory-prefix=/local_repo/octave \
  https://launchpad.net/~octave/+archive/ubuntu/stable/+build/5921916/+files/liboctave2_3.8.1-1ubuntu1~octave1~precise1_amd64.deb \
  https://launchpad.net/~octave/+archive/ubuntu/stable/+build/5921916/+files/octave_3.8.1-1ubuntu1~octave1~precise1_amd64.deb \
  https://launchpad.net/~octave/+archive/ubuntu/stable/+build/5921916/+files/liboctave-dev_3.8.1-1ubuntu1~octave1~precise1_amd64.deb \
  https://launchpad.net/~octave/+archive/ubuntu/stable/+build/5921916/+files/octave-dbg_3.8.1-1ubuntu1~octave1~precise1_amd64.deb \
  https://launchpad.net/~octave/+archive/ubuntu/stable/+files/octave-common_3.8.1-1ubuntu1~octave1~precise1_all.deb \
  https://launchpad.net/~octave/+archive/ubuntu/stable/+files/octave-doc_3.8.1-1ubuntu1~octave1~precise1_all.deb \
  https://launchpad.net/~octave/+archive/ubuntu/stable/+files/octave-info_3.8.1-1ubuntu1~octave1~precise1_all.deb

RUN cd /local_repo/octave && dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

RUN echo "deb [arch=amd64] file:/local_repo/octave ./" >> /etc/apt/sources.list

RUN apt-get update

# Install octave
RUN apt-get install --force-yes -y \
  bison \
  build-essential \
  cmake \
  cmake-curses-gui \
  flex \  
  g++ \
  imagemagick \
  libxi-dev \
  libxi6 \
  libxmu-dev \
  libxmu-headers \
  libxmu6 \  
  unzip \
  graphviz \
  xpdf \
  liboctave-dev 
  

# Fetch Octave forge packages
RUN mkdir /home/octave
RUN wget http://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/control-2.8.0.tar.gz -P /home/octave
RUN wget http://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/general-1.3.4.tar.gz -P /home/octave
RUN wget http://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/signal-1.3.0.tar.gz -P /home/octave
RUN wget http://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/image-2.2.2.tar.gz -P /home/octave
RUN wget http://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/io-2.0.2.tar.gz -P /home/octave
RUN wget http://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/statistics-1.2.4.tar.gz -P /home/octave

# Install Octave forge packages
RUN octave --eval "cd /home/octave; \
                   more off; \
                   pkg install -auto -global -verbose \
                   control-2.8.0.tar.gz \
                   general-1.3.4.tar.gz \
                   signal-1.3.0.tar.gz \
                   image-2.2.2.tar.gz \
                   io-2.0.2.tar.gz \
                   statistics-1.2.4.tar.gz"

# Build octave configure file
RUN echo more off >> /etc/octave.conf
RUN echo save_default_options\(\'-7\'\)\; >> /etc/octave.conf
RUN echo graphics_toolkit gnuplot >> /etc/octave.conf


COPY MTRDemo.ipynb $HOME/work
COPY README.ipynb $HOME/work
COPY demoMTR.mat $HOME/work
COPY lgnPlot.ipynb $HOME/work
COPY ReadFrame.tar.gz $HOME/work
COPY initPackages.m $HOME/work
COPY setNifti.m $HOME/work





