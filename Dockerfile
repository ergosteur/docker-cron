FROM ubuntu:latest

# Install cron
RUN apt-get update \
    && apt-get -y install --no-install-recommends cron ffmpeg python3 python3-pip youtube-dl atomicparsley \
    && pip install --upgrade --no-cache-dir pip youtube-dl

# Configure locale

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/simple-cron

# Add shell script and grant execution rights
ADD script.sh /script.sh
RUN chmod +x /script.sh

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/simple-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log
