# geektechstuff
# using a lot of https://hub.docker.com/r/philm/ansible_playbook/dockerfile/

# Alpine is a lightweight version of Linux.
# apline:latest could also be used
FROM alpine:3.7

RUN \
# apk add installs the following
 apk add \
   curl \
   python \
   py-pip \
   py-boto \
   py-dateutil \
   py-httplib2 \
   py-jinja2 \
   py-paramiko \
   py-setuptools \
   py-yaml \
   openssh-client \
   bash \
   tar && \
 pip install --upgrade pip
RUN curl http://ccrypt.sourceforge.net/download/1.11/ccrypt-1.11.linux-x86_64.tar.gz -o /tmp/ccrypt-1.11.linux-x86_64.tar.gz && cd /tmp && tar -zxf ccrypt-1.11.linux-x86_64.tar.gz && cp ccrypt-1.11.linux-x86_64/* /bin/ && rm -rf /tmp/
# Makes the Ansible directories
RUN mkdir /etc/ansible /ansible
RUN mkdir ~/.ssh

# Over rides SSH Hosts Checking
RUN echo "host *" >> ~/.ssh/config &&\
    echo "StrictHostKeyChecking no" >> ~/.ssh/config

# Downloads the Ansible tar (curl) and saves it (-o)
RUN \
  curl -fsSL https://releases.ansible.com/ansible/ansible-2.9.3.tar.gz -o ansible.tar.gz && \
  tar -xzf ansible.tar.gz -C ansible --strip-components 1 && \
  rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging

# Makes a directory for ansible playbooks
RUN mkdir -p /ansible/playbooks
# Makes the playbooks directory the working directory
WORKDIR /ansible/playbooks

# Sets environment variables
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING False
ENV ANSIBLE_RETRY_FILES_ENABLED False
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib
RUN curl -L --insecure https://networkgenomics.com/try/mitogen-0.2.9.tar.gz -o /etc/mitogen.tar.gz && \
    tar -xvzf /etc/mitogen.tar.gz && mv mitogen-0.2.9 /etc/mitogen  && \
    echo -e "[defaults]\nstrategy_plugins = /etc/mitogen/ansible_mitogen/plugins/strategy \nstrategy = mitogen_linear" > /etc/ansible/ansible.cfg



# Sets entry point (same as running ansible-playbook)
#ENTRYPOINT ["bash"]
# Can also use ["ansible"] if wanting it to be an ad-hoc command version
#ENTRYPOINT ["ansible"]
