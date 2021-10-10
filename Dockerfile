FROM ubuntu:focal

# Add crontab file in the cron directory
ADD backups-cron /etc/cron.d/backups-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/backups-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# install cron and convenient programs
RUN apt-get update && apt-get -y install cron vim

# add all the cronjobs to the crontab
RUN crontab /etc/cron.d/backups-cron

# execute cronjobs
RUN cron && tail -f /var/log/cron.log
