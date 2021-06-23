FROM dddlab/python-notebook:v20200331-df7ed42-94fdd01b492f

LABEL maintainer="Patrick Windmiller <sysadmin@pstat.ucsb.edu>"

USER root

RUN apt-get update && \
    apt-get install -y vim

USER $NB_UID

RUN conda update -n base conda && \
    conda update python && \
    pip install vdiff

RUN \
    # Notebook extensions (TOC extension)
    pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --sys-prefix && \
    jupyter nbextension enable toc2/main --sys-prefix && \
    jupyter nbextension enable toggle_all_line_numbers/main --sys-prefix && \
    jupyter nbextension enable table_beautifier/main --sys-prefix && \
    \
    # Notebook extensions configurator (server on and interface off)
    jupyter nbextension install jupyter_nbextensions_configurator --py --sys-prefix && \
    jupyter nbextensions_configurator disable --sys-prefix && \
    jupyter serverextension enable jupyter_nbextensions_configurator --sys-prefix && \
    \
    # update JupyterLab (required for @jupyterlab/toc)
    conda install -c conda-forge jupyterlab=2.2.0 && \
    \
    # add support for Matplotlib Magics
    conda install -c conda-forge ipympl==0.5.3 && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager jupyter-matplotlib@0.7.2 && \
    \
    # jupyter lab extensions
    jupyter labextension install @jupyterlab/google-drive && \
    jupyter labextension install @jupyterlab/toc --clean && \
    jupyter lab build && \
    pip install datascience && \
    \
    # remove cache
    rm -rf ~/.cache/pip ~/.cache/matplotlib ~/.cache/yarn && \
    rm -rf /opt/conda/share/jupyter/lab/extensions/jupyter-matplotlib-0.7.1.tgz

#--- Install nbgitpuller
RUN pip install nbgitpuller && \
    jupyter serverextension enable --py nbgitpuller --sys-prefix

RUN conda install -c conda-forge nodejs && \
    conda install -c conda-forge spacy && \
    conda install --quiet -y nltk && \
    conda install --quiet -y mplcursors && \
    conda install --quiet -y pytest && \
    conda install --quiet -y tweepy

RUN pip install PTable && \
    pip install pytest-custom-report

# Install otter-grader
RUN pip install otter-grader==2.1.1

RUN jupyter lab build && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

