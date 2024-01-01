FROM ghcr.io/appleboy/drone-scp:1.6.14

COPY entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
