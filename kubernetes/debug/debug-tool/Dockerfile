FROM ubuntu:24.04

# metadata
LABEL image.authors="ekambaram.pasham@gmail.com" \
	  image.title="Debug Container"

RUN apt update && apt upgrade -y

# install tools and dependencies
RUN apt-get install -y \
	ca-certificates curl dnsutils wget vim git \
	iproute2 iputils-ping iptables telnet tcpdump netcat-traditional net-tools \
	traceroute ssh sudo tree jq 

# apt clean up
RUN apt-get autoremove -y && \
    apt-get clean
	
CMD ["/bin/bash"]

