#!/usr/bin/env bash

brew update && brew upgrade && brew cleanup

brew link --overwrite python
brew link --overwrite gmp
brew link --overwrite node
brew postinstall node
brew link --overwrite redis
brew link --overwrite mpfr

brew update && brew upgrade && brew cleanup