FROM alpine:latest

RUN apk --update --no-cache add bash curl jq

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin

COPY retrieveparams.sh /retrieveparams.sh
RUN chmod +x /retrieveparams.sh

ENTRYPOINT ["/retrieveparams.sh"]
