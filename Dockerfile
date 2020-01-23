FROM debian:buster-slim

ENV SINUS_DIR="/opt/sinusbot" \
    SINUSBOT_VERSION="1.0.0-beta.10-202ee4d"

LABEL flavour="openshift"
EXPOSE 8087

# Install dependencies and clean up afterwards
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates \
    bzip2 unzip curl python procps libpci3 libxslt1.1 libxkbcommon0 \
    x11vnc xvfb libxcursor1 libnss3 libegl1-mesa libasound2 libglib2.0-0 libxcomposite-dev less jq && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# install youtube dl
RUN	curl -s -L -o /usr/local/bin/youtube-dl https://yt-dl.org/downloads/latest/youtube-dl && \
	chmod 755 /usr/local/bin/youtube-dl && \
	echo "Successfully installed youtube-dl"

WORKDIR $SINUS_DIR

COPY *.sh .
RUN useradd -u 1001 -g 0 -d "$SINUS_DIR" sinusbot && \
    chown -R sinusbot:0 "$SINUS_DIR" && \
    chmod g+rw "$SINUS_DIR" && \
    chmod 755 entrypoint.sh install.sh

USER 1001

# Download/Install SinusBot
RUN bash install.sh sinusbot && \
    chmod g+rw ./ default_scripts/ data/ scripts/

# Download/Install Text-to-Speech
RUN bash install.sh text-to-speech

# Download/Install TeamSpeak Client
RUN bash install.sh teamspeak

#  new entrypoint
ENTRYPOINT ["/opt/sinusbot/entrypoint.sh"]

# run as uid 1001 (its important to use uid instead of name)
USER 1001