#!/usr/bin/env sh

# Disable false positives shellcheck warnings
# shellcheck disable=SC1083,SC2005,SC2006,SC2015,SC2030,SC2031
# shellcheck disable=SC2034,SC2046,SC2116,SC2142,SC2194,SC2248
# shellcheck disable=SC2249,SC2250,SC2268,SC3037,SC3040

# Be more Bourne compatible
DUALCASE=1; export DUALCASE # for MKS sh
if test ${ZSH_VERSION+y} && (emulate sh) >/dev/null 2>&1
then :
  emulate sh
  NULLCMD=:
  # Pre-4.2 versions of Zsh do word splitting on ${1+"$@"}, which
  # is contrary to our usage.  Disable this feature.
  alias -g '${1+"$@"}'='"$@"'
  setopt NO_GLOB_SUBST
else case e in #(
  e) case `(set -o) 2>/dev/null` in #(
  *posix*) :
    set -o posix ;; #(
  *) :
     ;;
esac ;;
esac
fi

# Reset variables that may have inherited troublesome values from
# the environment.
as_nl='
'
export as_nl
IFS=" ""	${as_nl}"

PS1='$ '
PS2='> '
PS4='+ '

# Ensure predictable behavior from utilities with locale-dependent output.
LC_ALL=C
export LC_ALL
LANGUAGE=C
export LANGUAGE

# We cannot yet rely on "unset" to work, but we need these variables
# to be unset--not just set to an empty or harmless value--now, to
# avoid bugs in old shells (e.g. pre-3.0 UWIN ksh).  This construct
# also avoids known problems related to "unset" and subshell syntax
# in other old shells (e.g. bash 2.01 and pdksh 5.2.14).
for as_var in BASH_ENV ENV MAIL MAILPATH CDPATH
do eval test \${$as_var+y} \
  && ( (unset ${as_var}) || exit 1) >/dev/null 2>&1 && unset ${as_var} || :
done

# Ensure that fds 0, 1, and 2 are open.
if (exec 3>&0) 2>/dev/null; then :; else exec 0</dev/null; fi
if (exec 3>&1) 2>/dev/null; then :; else exec 1>/dev/null; fi
if (exec 3>&2)            ; then :; else exec 2>/dev/null; fi

# The user is always right.
if ${PATH_SEPARATOR+false} :; then
  PATH_SEPARATOR=:
  (PATH='/bin;/bin'; FPATH=$PATH; sh -c :) >/dev/null 2>&1 && {
    (PATH='/bin:/bin'; FPATH=$PATH; sh -c :) >/dev/null 2>&1 ||
      PATH_SEPARATOR=';'
  }
fi

# Find who we are.  Look in the path if we contain no directory separator.
as_myself=
case $0 in #((
  *[\\/]* ) as_myself=$0 ;;
  *) as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
for as_dir in $PATH
do
  IFS=$as_save_IFS
  case $as_dir in #(((
    '') as_dir=./ ;;
    */) ;;
    *) as_dir=$as_dir/ ;;
  esac
    test -r "$as_dir$0" && as_myself=$as_dir$0 && break
  done
IFS=$as_save_IFS

     ;;
esac

# We did not find ourselves, most probably we were run as 'sh COMMAND'
# in which case we are not to be found in the path.
if test "x${as_myself}" = x; then
  as_myself="${0}"
fi
if test ! -f "${as_myself}"; then
  printf "%s\n" "${as_myself}: error: cannot find myself; rerun with an absolute file name" >&2
  exit 1
fi

# Use a proper internal environment variable to ensure we don't fall
  # into an infinite loop, continuously re-executing ourselves.
  if test x"${_as_can_reexec}" != xno && test "x$CONFIG_SHELL" != x; then
    _as_can_reexec=no; export _as_can_reexec;
    # We cannot yet assume a decent shell, so we have to provide a
# neutralization value for shells without unset; and this also
# works around shells that cannot unset nonexistent variables.
# Preserve -v and -x to the replacement shell.
BASH_ENV=/dev/null
ENV=/dev/null
(unset BASH_ENV) >/dev/null 2>&1 && unset BASH_ENV ENV
case $- in # ((((
  *v*x* | *x*v* ) as_opts=-vx ;;
  *v* ) as_opts=-v ;;
  *x* ) as_opts=-x ;;
  * ) as_opts= ;;
esac
exec $CONFIG_SHELL $as_opts "${as_myself}" ${1+"$@"}
# Admittedly, this is quite paranoid, since all the known shells bail
# out after a failed 'exec'.
printf "%s\n" "$0: could not re-execute with $CONFIG_SHELL" >&2
exit 255
  fi
  # We don't want this to propagate to other subprocesses.
          { _as_can_reexec=; unset _as_can_reexec;}
if test "x$CONFIG_SHELL" = x; then
  as_bourne_compatible="if test \${ZSH_VERSION+y} && (emulate sh) >/dev/null 2>&1
then :
  emulate sh
  NULLCMD=:
  # Pre-4.2 versions of Zsh do word splitting on \${1+\"\$@\"}, which
  # is contrary to our usage.  Disable this feature.
  alias -g '\${1+\"\$@\"}'='\"\$@\"'
  setopt NO_GLOB_SUBST
else case e in #(
  e) case \`(set -o) 2>/dev/null\` in #(
  *posix*) :
    set -o posix ;; #(
  *) :
     ;;
esac ;;
esac
fi
"
  as_required="as_fn_return () { (exit \$1); }
as_fn_success () { as_fn_return 0; }
as_fn_failure () { as_fn_return 1; }
as_fn_ret_success () { return 0; }
as_fn_ret_failure () { return 1; }

exitcode=0
as_fn_success || { exitcode=1; echo as_fn_success failed.; }
as_fn_failure && { exitcode=1; echo as_fn_failure succeeded.; }
as_fn_ret_success || { exitcode=1; echo as_fn_ret_success failed.; }
as_fn_ret_failure && { exitcode=1; echo as_fn_ret_failure succeeded.; }
if ( set x; as_fn_ret_success y && test x = \"\$1\" )
then :

else case e in #(
  e) exitcode=1; echo positional parameters were not saved. ;;
esac
fi
test x\$exitcode = x0 || exit 1
blah=\$(echo \$(echo blah))
test x\"\$blah\" = xblah || exit 1
test -x / || exit 1"
  as_suggested="  as_lineno_1=";as_suggested=$as_suggested$LINENO;as_suggested=$as_suggested" as_lineno_1a=\$LINENO
  as_lineno_2=";as_suggested=$as_suggested$LINENO;as_suggested=$as_suggested" as_lineno_2a=\$LINENO
  eval 'test \"x\$as_lineno_1'\$as_run'\" != \"x\$as_lineno_2'\$as_run'\" &&
  test \"x\`expr \$as_lineno_1'\$as_run' + 1\`\" = \"x\$as_lineno_2'\$as_run'\"' || exit 1"
  if (eval "$as_required") 2>/dev/null
then :
  as_have_required=yes
else case e in #(
  e) as_have_required=no ;;
esac
fi
  if test "x${as_have_required}" = xyes && (eval "$as_suggested") 2>/dev/null
then :

else case e in #(
  e) as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
as_found=false
for as_dir in /bin$PATH_SEPARATOR/usr/bin$PATH_SEPARATOR$PATH
do
  IFS=$as_save_IFS
  case $as_dir in #(((
    '') as_dir=./ ;;
    */) ;;
    *) as_dir=$as_dir/ ;;
  esac
  as_found=:
  case $as_dir in #(
	 /*)
	   for as_base in sh bash ksh sh5; do
	     # Try only shells that exist, to save several forks.
	     as_shell=$as_dir$as_base
	     if { test -f "$as_shell" || test -f "$as_shell.exe"; } &&
		    as_run=a "$as_shell" -c "$as_bourne_compatible""$as_required" 2>/dev/null
then :
  CONFIG_SHELL=$as_shell as_have_required=yes
		   if as_run=a "$as_shell" -c "$as_bourne_compatible""$as_suggested" 2>/dev/null
then :
  break 2
fi
fi
	   done;;
       esac
  as_found=false
done
IFS=$as_save_IFS
if $as_found
then :

else case e in #(
  e) if { test -f "$SHELL" || test -f "$SHELL.exe"; } &&
	      as_run=a "$SHELL" -c "$as_bourne_compatible""$as_required" 2>/dev/null
then :
  CONFIG_SHELL=$SHELL as_have_required=yes
fi ;;
esac
fi


      if test "x$CONFIG_SHELL" != x
then :
  export CONFIG_SHELL
             # We cannot yet assume a decent shell, so we have to provide a
# neutralization value for shells without unset; and this also
# works around shells that cannot unset nonexistent variables.
# Preserve -v and -x to the replacement shell.
BASH_ENV=/dev/null
ENV=/dev/null
(unset BASH_ENV) >/dev/null 2>&1 && unset BASH_ENV ENV
case $- in # ((((
  *v*x* | *x*v* ) as_opts=-vx ;;
  *v* ) as_opts=-v ;;
  *x* ) as_opts=-x ;;
  * ) as_opts= ;;
esac
exec $CONFIG_SHELL $as_opts "${as_myself}" ${1+"$@"}
# Admittedly, this is quite paranoid, since all the known shells bail
# out after a failed 'exec'.
printf "%s\n" "$0: could not re-execute with $CONFIG_SHELL" >&2
exit 255
fi

    if test "x${as_have_required}" = xno
then :
  printf "%s\n" "$0: This script requires a shell more modern than all"
  printf "%s\n" "$0: the shells that I found on your system."
  if test ${ZSH_VERSION+y} ; then
    printf "%s\n" "$0: In particular, zsh $ZSH_VERSION has bugs and should"
    printf "%s\n" "$0: be upgraded to zsh 4.3.4 or later."
  else
    printf "%s\n" "$0: Please tell developer@lohann.dev about
$0: your system, including any error possibly output before
$0: this message. Then install a modern shell, or manually run
$0: the script under such a shell if you do have one."
  fi
  exit 1
fi ;;
esac
fi
fi
SHELL=${CONFIG_SHELL-/bin/sh}
export SHELL
# Unset more variables known to interfere with behavior of common tools.
# shellcheck disable=SC1007
CLICOLOR_FORCE= GREP_OPTIONS=
unset CLICOLOR_FORCE GREP_OPTIONS

# Determine whether it's possible to make 'echo' print without a newline.
# These variables are no longer used directly by Autoconf, but are AC_SUBSTed
# for compatibility with existing Makefiles.
# shellcheck disable=SC1007
ECHO_C= ECHO_N= ECHO_T=
case `echo -n x` in #(((((
-n*)
  case `echo 'xy\c'` in
  *c*) ECHO_T='	';;	# ECHO_T is single tab character.
  xy)  ECHO_C='\c';;
  *)   echo `echo ksh88 bug on AIX 6.1` > /dev/null
       ECHO_T='	';;
  esac;;
*)
  ECHO_N='-n';;
esac

#################################
## SHELL FUNCTIONS AND HELPERS ##
#################################
# fn_unset <VAR>
# ---------------
# Portably unset VAR.
fn_unset ()
{
  { eval "${1}="; unset "${1}"; }
} # fn_unset

# fn_set_status <STATUS>
# -----------------------
# Set $? to STATUS, without forking.
fn_set_status ()
{
  return "${1}"
} # fn_set_status

# fn_exit <STATUS>
# -----------------
# Exit the shell with STATUS, even in a "trap 0" or "set -e" context.
fn_exit ()
{
  set +e
  fn_set_status "${1}"
  exit "${1}"
} # fn_exit

# as_fn_executable_p <FILE>
# -----------------------
# Test if FILE is an executable regular file.
as_fn_executable_p ()
{
  test -f "${1}" && test -x "${1}"
} # as_fn_executable_p

# fn_as_arith [<ARG1> <ARG2> ...]
# ------------------
# Perform arithmetic evaluation on the ARGs, and store the result in the
# global $as_val. Take advantage of shells that can avoid forks. The arguments
# must be portable across $(()) and expr.
if (eval "test \$(( 1 + 1 )) = 2") 2>/dev/null
then :
  eval 'fn_as_arith ()
  {
    as_val=$(( $* ))
  }'
else case e in #(
  e) fn_as_arith ()
  {
    # shellcheck disable=SC2003
    as_val="$(expr "$@" || test $? -eq 1)"
  } ;;
esac
fi # fn_as_arith

# fn_append <VAR> <VALUE>
# ----------------------
# Append the text in VALUE to the end of the definition contained in VAR. Take
# advantage of any shell optimizations that allow amortized linear growth over
# repeated appends, instead of the typical quadratic growth present in naive
# implementations.
if (eval "as_var=1; as_var+=2; test x\$as_var = x12") 2>/dev/null
then :
  eval 'fn_append ()
  {
    eval $1+=\$2
  }'
else case e in #(
  e) fn_append ()
  {
    eval "${1}=\"\$${1}\${2}\""
  } ;;
esac
fi # fn_append

# fn_merge_args <VAR> [<ARG1> <ARG2> ...]
# ----------------------
# append multiple values to <VAR>
fn_merge_args ()
{
    var="${1}"
    shift
    if eval "test -z \${${var}+x} || test \"\${#${var}}\" = '0'"
    then eval "${var}=\"$(sh_quote "$*" 2>&1 || true)\""
    else fn_append "${var}" " $*"
    fi
} # fn_merge_args

# fn_abort <MESSAGE>
# -----------------
# display a message then exit
fn_abort ()
{
  printf "%s\n" "${1}" >&2
  fn_exit 1
} # fn_abort

# fn_find_bin [<BIN_1> <BIN_2> ...]
# ---------------
# Find a binary given a priority
fn_find_bin ()
{
    v=''
    for v; do
        if eval 'v="$(command -v "${v}" 2>&1)"'
        then break
        else v=''
        fi
    done
    # shellcheck disable=SC2310
    if test -n "${v}" && as_fn_executable_p "${v}"
    then printf '%s' "${v}"
    else fn_exit 1
    fi
} # fn_find_bin

# fn_sanitize_filename <tag>
# ---------------
# replace non-alphanumeric characteres by '-'
fn_sanitize_filename ()
{
    test -z ${_sed+x} || _sed='sed';
    printf '%s' "${1}" | "${_sed}" 's/[^A-Za-z0-9_]/-/g'
} # fn_sanitize_filename

# fn_sh_quote <text>
# ---------------
# escape shell special characters
fn_sh_quote ()
{
    v="$(printf '%s' "${1}" | sed "s/'/'\\\\''/g")"
    test "x${v}" = "x${v#*[!A-Za-z0-9_/.+-]}" || v="'${v}'"
    printf '%s' "${v}"
} # fn_sh_quote

# fn_repeat <text> <n>
# ---------------
# print `text` `n` times
fn_repeat ()
{
    d="${1}"
    fn_as_arith "${2}" + 0
    v="${as_val}"
    while test "${v}" -gt '0'
    do
        fn_as_arith "${v}" '%' '2'
        test "${as_val}" -eq '1' && printf '%s' "${d}"
        fn_as_arith "${v}" '/' '2'
        v="${as_val}"
        d="${d}${d}"
    done
} # fn_repeat

# fn_fmt_command <command> [args...]
# ---------------
# break a command in multiple lines if it doesn't fit in 80 columns.
fn_fmt_command ()
{
    v="$*"
    if test "${#v}" -gt '80'
    then
        if test "$#" -gt '1'
        then printf -- '$ %s \\\n' "${1}"
        else printf -- '$ %s\n' "${1}"
        fi
        shift;
        while test "$#" -gt '0'
        do
            if test "$#" -gt '1'
            then printf -- '     %s \\\n' "${1}"
            else printf -- '     %s\n' "${1}"
            fi
            shift;
        done
    else
        echo "\$ ${v}"
    fi
} # fn_fmt_command

# fn_show_header <SEPARATOR> <TITLE> <COLUMNS>
# ---------------
# display header
fn_show_header ()
{
    fn_as_arith "${#2}" '+' '2'
    v="${as_val}"
    fn_as_arith "${3}" '+' '0'
    if test "${v}" -lt "${as_val}"; then
        fn_as_arith "${3}" '-' "${#2}"
        fn_as_arith "${as_val}" '-' '2'
        fn_as_arith "${as_val}" '/' '2'
        v="$(fn_repeat "${1}" "${as_val}")"
        fn_as_arith "${#2}" '%' '2'
        if test "${as_val}" = '1'
        then printf '%s %s %s\n' "${v}" "${2}" "${v}${1}"
        else printf '%s %s %s\n' "${v}" "${2}" "${v}"
        fi
    else
        printf '%s\n' "${2}"
    fi
} # fn_show_header

# fn_try_exec <command> [args...]
# ---------------
# run or dry-run depending wether `_dry_run` is enabled/disabeld
fn_try_exec ()
{
    s='0'
    if eval 'as_cmd="$(quote_args_v2 "$@" 2>&1)" || s="$?"'
    then eval "as_out=\"\$(${as_cmd} 2>&1)\"" || s="$?"
    fi
    fn_set_status "${s}"
} # fn_try_exec

# fn_exec_or_abort <command> [args...]
# ---------------
# run or dry-run depending wether `_dry_run` is enabled/disabeld
fn_exec_or_abort ()
{
  s='0'
  # shellcheck disable=SC2310
  fn_try_exec "$@" || s="$?"
  if test "${s}" != '0'
  then
    printf '%s\n' "[ERROR] command failed with status ${s}" >&2
    printf '$ %s\n' "${as_cmd}" >&2
    fn_exit 1
  fi
  fn_set_status "${s}"
} # fn_exec_or_abort

# fn_dry_run <header> <command> [args...]
# ---------------
# run or dry-run depending wether `_dry_run` is enabled/disabeld
fn_dry_run ()
{
    fn_show_header '=' "${1}" 80
    shift;
    fn_fmt_command "$@"
    if test "${_dry_run:-0}" = '0'
    then
        fn_show_header '.' 'output' 80
        eval "$*"
    fi
    # shellcheck disable=SC2310
    printf '%s\n\n' "$(fn_repeat '-' 80 2>&1 || true)"
} # fn_dry_run

# fn_map <function> [items...]
# ---------------
# map values
fn_map ()
{
  m="${1}"
  shift
  for v; do eval "${m}"; done
} # fn_map

# fn_quote_args [args...]
# ---------------
# print args quoted
fn_quote_args ()
{
  # shellcheck disable=SC2310
  printf '%s' "$(fn_sh_quote "${1}" 2>&1 || true)"
  shift
  for v; do
    # shellcheck disable=SC2310
    printf ' %s' "$(fn_sh_quote "${v}" 2>&1 || true)";
  done
} # fn_quote_args

# fn_join <SEPARATOR> [values...]
# ---------------
# join values
fn_join ()
{
    s="${1}"
    printf '%s' "${2}"
    shift 2
    for v; do printf '%s%s' "${s}" "${v}"; done
} # fn_join

# fn_detect_arch
# ---------------
# detect host architecture
fn_detect_arch ()
{
    if command -v dpkg > /dev/null 2>&1; then
        # Detect architecture using `dpkg`
        v="$(dpkg --print-architecture 2>&1)" || fn_abort "${v}"
        case "${v}" in
            'amd64')        printf '%s' 'amd64'    ;;
            'i386')         printf '%s' '386'      ;;
            'arm64')        printf '%s' 'arm64/v8' ;;
            'armhf')        printf '%s' 'arm/v7'   ;;
            'riscv64')      printf '%s' 'riscv64'  ;;
            'ppc64el')      printf '%s' 'ppc64le'  ;;
            's390x')        printf '%s' 's390x'    ;;
            *)              printf '%s' "${v}"     ;;
        esac
    elif command -v uname > /dev/null 2>&1; then
        # Detect architecture using `uname`
        v="$(uname -m)" || fn_abort "${v}"
        case "${v}" in
            x86_64)         printf '%s' 'amd64'    ;;
            i*86)           printf '%s' '386'      ;;
            aarch64|arm64)  printf '%s' 'arm64/v8' ;;
            armv6l|armv7l)  printf '%s' 'arm/v7'   ;;
            riscv64)        printf '%s' 'riscv64'  ;;
            ppc64le|rs6000) printf '%s' 'ppc64le'  ;;
            *)              printf '%s' "${v}"     ;;
        esac
    else
        printf '%s' "unknown"
    fi
} # fn_detect_arch

# detect colors
if test -t 1 && command -v tput >/dev/null 2>&1; then
    ncolors="$(tput colors)"
    if test -n "${ncolors}" && test "${ncolors}" -ge 8; then
        bold_color="$(tput bold)"
        green_color="$(tput setaf 2)"
        warn_color="$(tput setaf 3)"
        error_color="$(tput setaf 1)"
        reset_color="$(tput sgr0)"
    fi
    # 72 used instead of 80 since that's the default of pr
    ncols=$(tput cols)
fi
: "${bold_color:=''}";
: "${green_color:=''}";
: "${warn_color:=''}";
: "${error_color:=''}";
: "${reset_color:=''}";
: "${ncols:=72}";

# fn_colorize <FORMAT> [params...]
# ---------------
# printf with colors
fn_colorize ()
{
    as_cmd="printf -- $(fn_sh_quote "${1}")"
    shift
    while test $# -gt '1'
    do
        case "${1}" in
            nn )        v="${2}";                                         ;;
            bb )        v="${bold_color}${2}${reset_color}"               ;;
            ww )        v="${warn_color}${2}${reset_color}"               ;;
            ee )        v="${error_color}${2}${reset_color}"              ;;
            bw | wb )   v="${bold_color}${warn_color}${2}${reset_color}"  ;;
            be | eb )   v="${bold_color}${error_color}${2}${reset_color}" ;;
            * )         fn_abort "[ERROR] fn_colorize: invalid format options: '${1}'" ;;
        esac
        shift 2;
        # shellcheck disable=SC2310
        v=" $(fn_sh_quote "${v}")" || fn_exit $?
        # shellcheck disable=SC2310
        fn_append 'as_cmd' "${v}" || fn_exit $?
    done
    fn_set_status 0
    eval "${as_cmd}" || fn_exit $?
} # fn_colorize

# fn_current_dir
# ---------------
# retrieve current directory
fn_current_dir ()
{
    fn_set_status 0
    if command -v pwd > /dev/null 2>&1
    then printf '%s' "$(pwd -P 2>&1 || true)" || fn_set_status "$?"
    elif test -z ${PWD+x}
    then printf '%s' "${PWD}" || fn_set_status "$?"
    else fn_set_status 1
    fi
} # fn_current_dir

# fn_print_failed_command
# ---------------
# Print the command in yellow, and the output in red
fn_print_failed_command ()
{
  printf >&2 "${bold_color}${warn_color}%s${reset_color}\n${error_color}%s${reset_color}\n" "${1}" "${2}"
} # fn_print_failed_command

# fn_exec_cmd <title> <command>
# ---------------
# Execute a command and only print it if it fails
fn_exec_cmd ()
{
  printf '  %s... ' "${1}"
  as_val=''
  if eval "as_val=\"\$( { $2 ;} 2>&1 )\"" > /dev/null; then
    # Success
    echo "${bold_color}${green_color}OK${reset_color}"
  else
    # Failure
    echo "${bold_color}${error_color}FAILED${reset_color}"
    fn_print_failed_command "$2" "${as_val}"
    fn_exit 1
  fi
} # fn_exec_cmd

######################
# CHECK DEPENDENCIES #
######################
(set -o pipefail) > /dev/null 2>&1 || true
set -eu

# Check if the `dirname` is installed
command -v 'dirname' > /dev/null 2>&1 || fn_abort "command 'dirname' not found"

# Check if the `sed` is installed
command -v 'sed' > /dev/null 2>&1 || fn_abort "command 'sed' not found"

# Check if the `cargo` is installed
command -v 'cargo' > /dev/null 2>&1 || fn_abort "command 'cargo' not found, please visit 'https://www.rust-lang.org/tools/install"

# Check if the `rustup` is installed
command -v 'rustup' > /dev/null 2>&1 || fn_abort "command 'rustup' not found, please visit 'https://www.rust-lang.org/tools/install"

# Check if the dprint is installed
if ! command -v dprint > /dev/null 2>&1; then
    fn_print_failed_command "dprint is not installed. Please install it by running:"
    printf '%s\n' "cargo install --locked dprint"
    fn_exit 1
fi

# Check if the cargo-deny is installed
if ! command -v cargo-deny > /dev/null 2>&1; then
    print_failed_command "cargo-deny is not installed. Please install it by running:"
    printf '%s\n' "cargo install --locked cargo-deny"
    fn_exit 1
fi

# Check if the shellcheck is installed
if ! command -v shellcheck > /dev/null 2>&1; then
    print_failed_command "shellcheck is not installed."
    printf '%s\n' "please visit 'https://github.com/koalaman/shellcheck?tab=readme-ov-file#installing"
    fn_exit 1
fi

#########################################
# FORMAT CODE AND CHECK VULNERABILITIES #
#########################################

# Make sure we are in the project root directory
cd "$(dirname "${as_myself}")" || fn_abort "Failed to change directory"
cd ..|| fn_abort "Failed to change directory"

# Format shell scripts
fn_exec_cmd 'shellcheck' 'shellcheck --enable=all --severity=style ./scripts/*.sh'

# Format rust code
fn_exec_cmd 'cargo fmt' 'cargo +nightly fmt --all'

# Format TOML, json markdown and dockerfiles
fn_exec_cmd 'dprint fmt' 'dprint fmt'

# Check package vulnerabilities and licenses
fn_exec_cmd 'cargo deny' 'cargo deny check'

# run cargo clippy
CLIPPY_FLAGS="-Dwarnings -Dclippy::unwrap_used -Dclippy::expect_used -Dclippy::nursery -Dclippy::pedantic -Aclippy::module_name_repetitions"
fn_exec_cmd 'cargo clippy' "cargo clippy --locked --workspace --examples --tests --all-features -- ${CLIPPY_FLAGS}"
