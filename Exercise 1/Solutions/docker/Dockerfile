#Basic Image
FROM aflplusplus/aflplusplus

#Args for compliance of inner and outer uid and gid
ARG cuid=1000
ARG cgid=1000
ARG cuidname=fuzzuser
ARG cgidname=docker

# Install requirements:
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && \
    apt-get install -y sudo wget

# Add group and user (like my HOST group and user):
RUN groupadd -g $cgid $cgidname && \
    useradd -m -u $cuid -g $cgidname -G sudo -s /usr/bin/bash $cuidname

# Build target:
ENV CC="afl-clang-fast" \
    CXX="afl-clang-fast++"

USER $cuidname
WORKDIR /home/$cuidname/
RUN wget https://dl.xpdfreader.com/old/xpdf-3.02.tar.gz && \
    tar -xvzf xpdf-3.02.tar.gz && \
    cd xpdf-3.02 && \
    ./configure --prefix="/home/$cuidname/fuzzing_xpdf/install/" && \
    make -j$(nproc) && \
    make install

# Get input:
RUN mkdir /home/$cuidname/pdf_examples && \
    cd /home/$cuidname/pdf_examples && \
    wget https://github.com/mozilla/pdf.js-sample-files/raw/master/helloworld.pdf && \
    wget http://www.africau.edu/images/default/sample.pdf && \
    wget https://www.melbpc.org.au/wp-content/uploads/2017/10/small-example-pdf-file.pdf

# Fuzzing:
USER root
ENV cuidname=$cuidname \
    cgidname=$cgidname \
    INPUT="/home/$cuidname/pdf_examples" \
    OUTPUT="/home/$cuidname/out" \
    TARGET="/home/$cuidname/fuzzing_xpdf/install/bin/pdftotext @@ /home/cuidname/fuzzing_xpdf/output"

CMD chown -R $cuidname:$cgidname $OUTPUT && \
    sudo -u $cuidname afl-fuzz -i $INPUT -o $OUTPUT -s 123 -- $TARGET

