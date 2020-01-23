FROM sinusbot/docker:latest

LABEL flavour="openshift"

ENV SINUS_DIR="/opt/sinusbot" 

# Add user for bot
RUN useradd -u 1001 -g 0 -d "$SINUS_DIR" sinusbot

# Assign sinusbot to
RUN chown -R sinusbot:0 "$SINUS_DIR" && \
    chmod g+rw . default_scripts data scripts

# update youtube-dl
RUN youtube-dl --restrict-filename -U

#  new entrypoint
ADD entrypoint.sh .
RUN chmod 755 entrypoint.sh

# run as uid 1001 (its important to use uid instead of name)
USER 1001