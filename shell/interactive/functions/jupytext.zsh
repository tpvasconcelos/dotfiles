py2nb() {
  jupytext --to notebook "${1}"
  jupytext --sync "${1}"
}

nb2py() {
  jupytext --to py:percent "${1}"
  jupytext --sync "${1}"
}
