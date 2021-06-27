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
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib

RUN adduser --create-home \
    --comment "Default user" \
    --uid ${NB_UID} \
    --home-dir ${HOME} \
    ${NB_USER}

RUN echo 'please update the files!'
ADD blob2d.py /
ADD *.ipynb /
RUN mv /blob2d.py /*.ipynb ${HOME}
RUN chown ${USER} ${HOME} -R
WORKDIR ${HOME}
USER ${USER}


