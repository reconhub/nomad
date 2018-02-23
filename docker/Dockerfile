FROM r-base

RUN apt-get update && apt-get install -y \
        libcurl4-openssl-dev \
        libssh2-1-dev \
        libssl-dev \
        libxml2-dev

RUN install2.r --error \
        R6 \
        curl \
        devtools \
        drat \
        prettyunits \
        progress \
        remotes \
        roxygen2 \
        rversions \
        storr \
        testthat \
        withr \
        yaml

RUN Rscript -e 'install.packages("provisionr", repos = "https://mrc-ide.github.io/drat")'

COPY . /src
RUN R CMD INSTALL /src && \
        Rscript -e 'nomad:::write_script("/usr/local/bin/nomad")' && \
        rm -rf /src

ENTRYPOINT ["nomad"]
CMD ["/build"]
