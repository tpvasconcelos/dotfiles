pipenv install ipython ipykernel jupyter jupyterlab --skip-lock
python -m ipykernel install --user --name="$(basename "$VIRTUAL_ENV")"
# OR: python -m ipython kernel install --user --name="$(basename "$VIRTUAL_ENV")"

# Extensions
pipenv run jupyter lab build
pipenv install black isort rpy2 blackcellmagic jupyterlab_code_formatter ipywidgets jupyter-dash --skip-lock
pipenv run jupyter labextension install @jupyterlab/toc @ryantam626/jupyterlab_code_formatter @jupyter-widgets/jupyterlab-manager@2.0 @oriolmirosa/jupyterlab_materialdarker jupyterlab-plotly @jupyter-widgets/jupyterlab-manager plotlywidget@4.9.0
jupyter serverextension enable --py jupyterlab_code_formatter
pipenv run jupyter lab build