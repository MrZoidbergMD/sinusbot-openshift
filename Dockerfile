FROM sinusbot/docker:latest

LABEL flavour="openshift"

ENV SINUS_DIR="/opt/sinusbot" 

# Add user for bot
RUN useradd -u 1001 -g 0 -d "$SINUS_DIR" sinusbot

# Assign sinusbot to
RUN chown -R sinusbot:0 "$SINUS_DIR"

# run as uid 1001 (its important to use uid instead of name)
USER 1001