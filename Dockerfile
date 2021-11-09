FROM ubuntu:focal

RUN mkdir /code
WORKDIR /app

# Add crontab file in the cron directory
ADD backups-cron /etc/cron.d/backups-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/backups-cron

# Create the log file to see if the crontab is alive
RUN touch /var/log/cron.log

# install cron and other convenient programs
RUN apt-get update && apt-get -y install cron vim python3 git

# add all the cronjobs to the crontab
RUN crontab /etc/cron.d/backups-cron

COPY . /app/
RUN chmod +x generators/* backup-scripts/*

# set destination of data files
ENV DATA_FOLDER=/app/app_data
RUN git init $DATA_FOLDER

# display messages that the cron is alive
# RUN tail -f /var/log/cron.log &

CMD cron && /bin/bash
