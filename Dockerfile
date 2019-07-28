FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:000000' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Free up some space
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Expose port 22 (default port for ssh)
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]