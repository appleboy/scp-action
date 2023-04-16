FROM ghcr.io/appleboy/drone-scp:1.6.9

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
