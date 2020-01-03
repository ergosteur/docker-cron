FROM debian:latest

# Install cron and other packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends cron ffmpeg python3 python3-pip youtube-dl atomicparsley \
    && pip3 install --upgrade --no-cache-dir pip youtube-dl

# Configure locale
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_CA.UTF-8 UTF-8/en_CA.UTF-8 UTF-8/' /etc/locale.gen
RUN dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_CA.UTF-8


ENV LANG en_CA.UTF-8  
ENV LANGUAGE en_CA:en  
ENV LC_ALL en_CA.UTF-8 

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
