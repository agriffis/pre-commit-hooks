#!/usr/bin/env bash

main() {
  require ghettopt.bash
  unset ${!opt_*} shortopts
  declare opt_strict=true
  ghettopt "$@" || exit
  set -- "${params[@]}"

  declare patt
  if $opt_strict; then
    patt='^\w+ (amend|fixup|squash)!'
  else
    patt='^\w+ [\w-]+!'
  fi

  # This uses grep instead of git log --grep because (1) git grep searches the
  # entire commit message, with no way to constrain to the first line, (2) we
  # need an exit code to signal whether the pattern was found.
  git log --oneline @{upstream}..HEAD | grep -Ee "$patt"

  # Invert the grep exit status.
  return $(($? != 0))
}

require() {
  local lib="$1" script="${BASH_SOURCE[1]}"
  if [[ $lib != /* && $script == */* ]]; then
    lib=${script%/*}/$lib
  fi
  source "$lib" || die "failed to load: $lib"
}

die() {
  echo "$1" >&2
  exit 1
}

opt_help() {
  cat <<EOT
usage: git-autosquash-check.bash [options]

  --no-strict  Check for any prefix ending with bang.
  --strict     Check only for amend!/fixup!/squash! prefixes. (default)

EOT
  exit
}

main "$@"; exit
