FROM python:3.11.0-buster AS base

# Setup env
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1

FROM base AS python-deps
# Install pipenv and compilation dependencies
RUN pip install -U pip pipenv
# Install python dependencies in /.venv
COPY Pipfile .
COPY Pipfile.lock .
RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy 

FROM base AS runtime
# Copy virtual env from python-deps stage
COPY --from=python-deps /.venv /.venv
ENV PATH="/.venv/bin:$PATH"
# Create and switch to a new user
RUN useradd --create-home ansibleuser
WORKDIR /home/ansibleuser
USER ansibleuser
# create ssh key for server
#   will need copy of '/home/ansibleuser/.ssh/id_rsa.pub'
#   on associated servers to '/home/$USER/.ssh/authorized_keys'
RUN ssh-keygen -t rsa -q -f /home/ansibleuser/.ssh/id_rsa -N ""
