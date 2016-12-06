FROM r-base:3.3.0
MAINTAINER markpeng@exosite.com

# install required R dependencies
RUN apt-get update && apt-get install -y openssh-server libcurl4-openssl-dev libssl-dev libxml2-dev

# setup R packages
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile && \
    Rscript -e "install.packages('Rserve')" && \
    Rscript -e "install.packages('fpp')" && \
    Rscript -e "install.packages('devtools')" && \
    Rscript -e "devtools::install_github('twitter/AnomalyDetection')"

# install elixir dependencies
RUN apt-get install -y erlang elixir erlang-snmp git htop curl

CMD ["R"]
