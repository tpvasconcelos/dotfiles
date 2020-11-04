# pipenv  ---

pipenv install ipython ipykernel jupyter jupyterlab --skip-lock
python -m ipykernel install --user --name="$(basename "$VIRTUAL_ENV")"
# OR: python -m ipython kernel install --user --name="$(basename "$VIRTUAL_ENV")"

# Extensions
pipenv run jupyter lab build
pipenv install black isort rpy2 blackcellmagic jupyterlab_code_formatter ipywidgets jupyter-dash --skip-lock
pipenv run jupyter labextension install @jupyterlab/toc @ryantam626/jupyterlab_code_formatter @jupyter-widgets/jupyterlab-manager@2.0 @oriolmirosa/jupyterlab_materialdarker jupyterlab-plotly @jupyter-widgets/jupyterlab-manager plotlywidget@4.9.0
jupyter serverextension enable --py jupyterlab_code_formatter
pipenv run jupyter lab build


# poetry  ---

poetry add ipython ipykernel jupyter jupyterlab
poetry run python -m ipykernel install --user --name="$(basename "$VIRTUAL_ENV")"
# OR: poetry run python -m ipython kernel install --user --name="$(basename "$VIRTUAL_ENV")"

# Extensions
poetry run jupyter lab build
poetry add black isort rpy2 blackcellmagic jupyterlab_code_formatter ipywidgets jupyter-dash
poetry run jupyter labextension install @jupyterlab/toc @ryantam626/jupyterlab_code_formatter @jupyter-widgets/jupyterlab-manager@2.0 @oriolmirosa/jupyterlab_materialdarker jupyterlab-plotly @jupyter-widgets/jupyterlab-manager plotlywidget@4.9.0
poetry run jupyter serverextension enable --py jupyterlab_code_formatter
poetry run jupyter lab build
