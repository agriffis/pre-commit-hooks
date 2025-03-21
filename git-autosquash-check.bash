#!/bin/bash

main() {
  git log --oneline --grep='^\(amend\|fixup\|squash\)!' @{upstream}..HEAD | grep .
  return $(($? != 0))
}

main "$@"; exit
