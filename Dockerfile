FROM jenkins/jenkins:alpine
USER root
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" &&\
chmod +x ./kubectl &&\
mv ./kubectl /usr/local/bin/kubectl &&\
apk add python3 &&\
apk add ansible
USER jenkins