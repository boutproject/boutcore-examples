FROM registry.fedoraproject.org/fedora:latest
# install the notebook package
RUN dnf -y update && dnf -y install python3-notebook python3-bout++-openmpi python3-xbout && dnf -y clean all

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

ADD https://raw.githubusercontent.com/boutproject/BOUT-dev/master/examples/boutcore/blob2d.py /
ADD simulation.ipynb /
RUN mv /blob2d.py /simulation.ipynb ${HOME}
RUN chown ${USER} ${HOME} -R
WORKDIR ${HOME}
USER ${USER}


