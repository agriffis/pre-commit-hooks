#!/bin/bash

main() {
  ! git log --oneline --grep='^\(amend\|fixup\|squash\)!' @{upstream}..HEAD | grep .
}


main "$@"; exit
