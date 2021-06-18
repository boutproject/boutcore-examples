FROM registry.fedoraproject.org/fedora:latest
# install the notebook package
RUN dnf -y update && dnf -y install python3-notebook python3-bout++-openmpi && dnf -y clean all

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

# setup mpi
ENV PYTHONPATH=/usr/lib64/python3.9/site-packages/openmpi

RUN adduser --create-home \
    --comment "Default user" \
    --uid ${NB_UID} \
    --home-dir ${HOME} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}

ADD https://raw.githubusercontent.com/boutproject/BOUT-dev/next/examples/boutcore/blob2d.py ${HOME}
