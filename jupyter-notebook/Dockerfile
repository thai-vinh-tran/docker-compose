FROM quay.io/jupyter/datascience-notebook
    
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

USER $NB_UID

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . /home/jovyan/work
WORKDIR /home/jovyan/work
