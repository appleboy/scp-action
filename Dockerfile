FROM appleboy/drone-scp:1.6.2-linux-amd64

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
