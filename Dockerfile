# start from the rocker/r-ver:latest image
FROM  10.2.200.51:5000/r-base-datalis:new

# install the linux libraries needed for plumber
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \
    libssh2-1-dev \
    libglpk-dev \
    libcurl4-openssl-dev \
    libssl-dev

## update system libraries
#RUN apt-get update && \
#    apt-get upgrade -y && \
#    apt-get clean

# copy everything from the current directory into the container
RUN rm -rf /app
run mkdir /app
COPY / ./app

# Install Package
RUN Rscript /app/install_packages.R

# open port 8013 to traffic
EXPOSE 8013


#Symlink folder  
RUN ln -s /apps/scorecard/source/api_scorecard /app/api_scorecard


# when the container starts, start the main.R script
ENTRYPOINT ["Rscript", "app/run_api.R"]
