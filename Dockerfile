FROM ubuntu:focal

# install convenient programs
RUN apt-get install vi nano
# install nessessary programs
RUN apt-get install python3

COPY . .

# creating cron jobs
RUN /bin/bash install.sh

# running example program that generates some files to backup
RUN python3 main.py

