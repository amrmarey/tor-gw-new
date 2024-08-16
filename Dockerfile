# Use an official Debian-based image
FROM debian:stable-slim

# Install Tor and necessary utilities
RUN apt-get update && apt-get install -y tor obfs4proxy && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user and group
RUN groupadd -r tor && useradd -r -g tor tor

# Create the necessary directory and set the correct permissions
RUN mkdir -p /home/tor/.tor && chown -R tor:tor /home/tor

# Ensure the necessary directories are writable
RUN chown -R tor:tor /home/tor/.tor /run /tmp && chmod -R 700 /home/tor/.tor

# Add Tor configuration file
COPY torrc /etc/tor/torrc

# Change ownership of the torrc file
RUN chown tor:tor /etc/tor/torrc

# Expose Tor SOCKS proxy port
EXPOSE 9050

# Run Tor as non-root user
USER tor

# Run Tor
CMD ["tor", "-f", "/etc/tor/torrc"]
