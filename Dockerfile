FROM appleboy/drone-scp:1.5.1-linux-amd64

# Github labels
LABEL "com.github.actions.name"="SCP"
LABEL "com.github.actions.description"="Copy files and artifacts via SSH"
LABEL "com.github.actions.icon"="copy"
LABEL "com.github.actions.color"="gray-dark"

LABEL "repository"="https://github.com/appleboy/scp-action"
LABEL "homepage"="https://github.com/appleboy"
LABEL "maintainer"="Bo-Yi Wu <appleboy.tw@gmail.com>"
LABEL "version"="0.0.1"

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
