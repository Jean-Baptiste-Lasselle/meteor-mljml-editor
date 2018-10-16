FROM centos:7

# Marguerite Distribution Management - digital signature

# 
RUN yum update -y && yum install -y git iputils vim net-tools curl wget iperf3 telnet telnet-server nmap 
RUN echo "  "
# RUN echo " Vérif installation netcat : "
# RUN echo "  "
# RUN export SORTIE_STD=$(ncat -v localhost) && echo "$SORTIE_STD" | grep Version
# RUN echo "  "
RUN echo " Vérif installation netstat : "
RUN echo "  "
RUN netstat --version
RUN netstat -tulpn
RUN echo "  "
RUN echo " Vérif installation iperf3 : "
RUN echo "  "
RUN iperf3 --version
RUN echo "  "
RUN echo " Vérif installation git : "
RUN echo "  "
RUN git --version
RUN echo "  "
RUN echo " Vérif installation curl : "
RUN echo "  "
RUN curl --version
RUN echo "  "
CMD ["/bin/bash"]
