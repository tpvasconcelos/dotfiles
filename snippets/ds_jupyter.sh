# pipenv  ---

pipenv install ipython ipykernel jupyter jupyterlab --skip-lock
python -m ipykernel install --user --name="$(basename "$VIRTUAL_ENV")"
# OR: python -m ipython kernel install --user --name="$(basename "$VIRTUAL_ENV")"

# Extensions
pipenv run jupyter lab build
pipenv install black isort blackcellmagic "ipywidgets>=7.5" jupyter-dash --skip-lock
pipenv run jupyter labextension install @jupyterlab/toc \
                                        @jupyter-widgets/jupyterlab-manager \
                                        jupyterlab-plotly \
                                        plotlywidget
pipenv run jupyter lab build


# poetry  ---
poetry add -D ipython ipykernel jupyter jupyterlab
env_name="$(basename "$(poetry env info -p)")"
poetry run python -m ipykernel install --user --name="${env_name}"
# OR: poetry run python -m ipython kernel install --user --name="$(basename "$VIRTUAL_ENV")"

# Extensions
poetry run jupyter lab build
poetry add -D black isort blackcellmagic "ipywidgets>=7.5" jupyter-dash
poetry run jupyter labextension install @jupyterlab/toc \
                                        @jupyter-widgets/jupyterlab-manager \
                                        jupyterlab-plotly \
                                        plotlywidget
poetry run jupyter lab build
