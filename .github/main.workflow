
workflow "Build and Test" {
  on = "push"
  resolves = [
    "Test",
  ]
}

action "Poetry" {
  uses = "nolanbconaway/python-actions@master"
  args = "curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python && source $HOME/.poetry/env"
}

action "Install" {
  uses = "nolanbconaway/python-actions@master"
  args = "poetry install && poetry shell && which python"
  needs = ["Poetry"]
}

action "Black" {
  uses = "nolanbconaway/python-actions@master"
  args = "black mta_realtime test --check --verbose"
  needs = ["Install"]
}


action "Pydocstyle" {
  uses = "nolanbconaway/python-actions@master"
  args = "pydocstyle mta_realtime test --verbose"
  needs = ["Install"]
}

action "Pylint" {
  uses = "nolanbconaway/python-actions@master"
  args = "pylint mta_realtime test -d C0303 -d C0412 -d C0330"
  needs = ["Install"]
}

action "Test" {
  uses = "nolanbconaway/python-actions@master"
  args = "pytest . -v"
  needs = ["Black", "Pydocstyle", "Pylint"]
}