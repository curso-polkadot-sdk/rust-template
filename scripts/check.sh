#!/usr/bin/env bash

set -e

# Ensure the script is run from the root of the repository
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "${SCRIPT_DIR}/../"

####################
# HELPER FUNCTIONS #
####################

# Setup console colors
if test -t 1 && command -v tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
    if test -n "${ncolors}" && test "${ncolors}" -ge 8; then
        bold_color=$(tput bold)
        green_color=$(tput setaf 2)
        warn_color=$(tput setaf 3)
        error_color=$(tput setaf 1)
        reset_color=$(tput sgr0)
    fi
    # 72 used instead of 80 since that's the default of pr
    ncols=$(tput cols)
fi
: "${ncols:=72}"

# Print the command in yellow, and the output in red
print_failed_command() {
  printf >&2 "${bold_color}${warn_color}%s${reset_color}\n${error_color}%s${reset_color}\n" "$1" "$2"
}

# Execute a command and only print it if it fails
exec_cmd() {
  printf '  %s... ' "$1"
  local cmdOutput
  if eval "cmdOutput=\$( { $2 ;} 2>&1 )" > /dev/null; then
    # Success
    echo "${bold_color}${green_color}OK${reset_color}"
  else
    # Failure
    echo "${bold_color}${error_color}FAILED${reset_color}"
    print_failed_command "$2" "${cmdOutput}"
    exit 1
  fi
}

######################
# CHECK DEPENDENCIES #
######################

# Check if the rustup is installed
if ! command -v rustup &> /dev/null; then
    print_failed_command "rustup is not installed."
    echo "please visit 'https://www.rust-lang.org/tools/install"
    exit 1
fi

# Check if the dprint is installed
if ! command -v dprint &> /dev/null; then
    print_failed_command "dprint is not installed. Please install it by running:"
    echo "cargo install --locked dprint"
    exit 1
fi

# Check if the cargo-deny is installed
if ! command -v cargo-deny -V &> /dev/null; then
    print_failed_command "cargo-deny is not installed. Please install it by running:"
    echo "cargo install --locked cargo-deny"
    exit 1
fi

# Check if the shellcheck is installed
if ! command -v shellcheck -V &> /dev/null; then
    print_failed_command "shellcheck is not installed."
    echo "please visit 'https://github.com/koalaman/shellcheck?tab=readme-ov-file#installing"
    exit 1
fi

#########################################
# FORMAT CODE AND CHECK VULNERABILITIES #
#########################################

exec_cmd 'format' 'cargo +nightly fmt --all'
exec_cmd 'format' 'dprint fmt'
exec_cmd 'format' 'cargo deny check'

CLIPPY_FLAGS="-Dwarnings -Dclippy::unwrap_used -Dclippy::expect_used -Dclippy::nursery -Dclippy::pedantic -Aclippy::module_name_repetitions"
exec_cmd 'format' "cargo clippy --locked --workspace --examples --tests --all-features -- ${CLIPPY_FLAGS}"
exec_cmd 'shellcheck' 'shellcheck --enable=all --severity=style ./scripts/*.sh'
