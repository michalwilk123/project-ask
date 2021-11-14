FROM ubuntu:focal
ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir /code
WORKDIR /app

# Create the log file to see if the crontab is alive
RUN touch /var/log/cron.log

# install cron and other convenient programs
RUN apt-get update && apt-get -y install cron vim python3 git
# RUN apt-get -y install git-annex # git extension for storing blobs

COPY . /app/
RUN rm -rf .git

# set destination of data files
RUN mkdir -p /app/backups
RUN chmod +x ask_backup.sh test_app.py && \
    ./ask_backup.sh install /app/app_data /app/backups /var/log/ask_backup.log
RUN chmod +x aa.sh

CMD cron && /bin/bash
