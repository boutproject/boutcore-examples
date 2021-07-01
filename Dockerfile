FROM registry.fedoraproject.org/fedora:latest
# install the notebook package
RUN dnf -y update && dnf -y install python3-notebook python3-bout++-openmpi python3-xbout bout++-openmpi-devel python3-pip && dnf -y clean all

# https://github.com/boutproject/BOUT-dev/pull/2360
touch /usr/include/openmpi-x86_64/bout++/makefile.submodules

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

# setup mpi / bout++
ENV PYTHONPATH=/usr/lib64/python3.9/site-packages/openmpi
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib
ENV BOUT_TOP=/usr/include/openmpi-x86_64/bout++/

RUN adduser --create-home \
    --comment "Default user" \
    --uid ${NB_UID} \
    --home-dir ${HOME} \
    ${NB_USER}

WORKDIR ${HOME}
USER ${USER}
RUN python3 -m ensurepip
RUN python3 -m pip install --upgrade animatplot
RUN echo 'please update the files!'
COPY . .
RUN rm README.md Dockerfile
