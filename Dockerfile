FROM python:3.8
WORKDIR /app
COPY . /app
FROM rocker/shiny-verse:4.0.0

RUN R -e "install.packages(c('rmarkdown', 'shinydashboard', 'scales', 'DT', 'zoo', 'plotly', 'data.table','lubridate','Hmisc'))" && \
    R -e "install.packages('https://cran.r-project.org/src/contrib/rappdirs_0.3.3.tar.gz', repo=NULL, type='source')" && \
    R -e "install.packages('https://cran.r-project.org/src/contrib/rlang_0.4.12.tar.gz', repo=NULL, type='source')" && \
    R -e "install.packages('https://cran.r-project.org/src/contrib/fastmap_1.1.0.tar.gz', repo=NULL, type='source')" && \
    R -e "install.packages('https://cran.r-project.org/src/contrib/htmltools_0.5.2.tar.gz', repo=NULL, type='source')" && \
    R -e "install.packages('https://cran.r-project.org/src/contrib/sass_0.4.0.tar.gz', repo=NULL, type='source')" && \
    R -e "install.packages('https://cran.r-project.org/src/contrib/jquerylib_0.1.4.tar.gz', repo=NULL, type='source')" && \
    R -e "install.packages('https://cran.r-project.org/src/contrib/bslib_0.3.1.tar.gz', repo=NULL, type='source')" && \
    R -e "install.packages('https://cran.r-project.org/src/contrib/cachem_1.0.6.tar.gz', repo=NULL, type='source')" && \
    R -e "install.packages('https://cran.r-project.org/src/contrib/rlang_0.4.12.tar.gz', repo=NULL, type='source')" && \
    R -e "install.packages('https://cran.r-project.org/src/contrib/fontawesome_0.2.2.tar.gz', repo=NULL, type='source')" && \
    R -e "install.packages('https://cran.r-project.org/src/contrib/shiny_1.7.1.tar.gz', repo=NULL, type='source')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    chown shiny:shiny /var/lib/shiny-server

EXPOSE 3838

#COPY shiny-server.sh /usr/bin/shiny-server.sh
#RUN chmod -R 755 /usr/bin/shiny-server.sh

#CMD ["/usr/bin/shiny-server.sh"]
CMD ["python", "main.py"]
