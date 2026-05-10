#!/usr/bin/env sh

# Disable false positives shellcheck warnings
# shellcheck disable=SC1083,SC2005,SC2006,SC2015,SC2030,SC2031
# shellcheck disable=SC2034,SC2046,SC2116,SC2142,SC2194,SC2248
# shellcheck disable=SC2249,SC2250,SC2268,SC3037,SC3040,SC2065
# shellcheck disable=SC1007,SC2121,SC2086,SC2310,SC2016,SC2319

# Be more Bourne compatible
DUALCASE=1; export DUALCASE # for MKS sh
if test ${ZSH_VERSION+y} && (emulate sh) > /dev/null 2>&1; then
  emulate sh
  # shellcheck disable=SC2034
  NULLCMD=:
  # Pre-4.2 versions of Zsh do word splitting on ${1+"$@"}, which
  # is contrary to our usage.  Disable this feature.
  # shellcheck disable=SC2142
  alias -g '${1+"$@"}'='"$@"'
  setopt NO_GLOB_SUBST
else
  # shellcheck disable=SC2006
  case `(set -o) 2> /dev/null` in
    *posix*)
      # shellcheck disable=SC3040
      set -o posix > /dev/null 2>&1 ;;
    *) : ;;
  esac
fi

# Reset variables that may have inherited troublesome values from
# the environment.
var_nl='
'
IFS=" ""	${var_nl}"
PS1='$ '
PS2='> '
PS4='+ '

# Ensure predictable behavior from utilities with locale-dependent output.
LC_ALL=C; export LC_ALL
LANGUAGE=C; export LANGUAGE
LANG=en_US.UTF-8; export LANG
test "${_var_can_reexec+y}" || unset LINENO

# We cannot yet rely on "unset" to work, but we need these variables
# to be unset--not just set to an empty or harmless value--now, to
# avoid bugs in old shells (e.g. pre-3.0 UWIN ksh).  This construct
# also avoids known problems related to "unset" and subshell syntax
# in other old shells (e.g. bash 2.01 and pdksh 5.2.14).
test ${BASH_ENV+y} && ( (unset BASH_ENV) || exit 1) > /dev/null 2>&1 && unset BASH_ENV || :
test ${ENV+y} && ( (unset ENV) || exit 1) > /dev/null 2>&1 && unset ENV || :
test ${MAIL+y} && ( (unset MAIL) || exit 1) > /dev/null 2>&1 && unset MAIL || :
test ${MAILPATH+y} && ( (unset MAILPATH) || exit 1) > /dev/null 2>&1 && unset MAILPATH || :
test ${CDPATH+y} && ( (unset CDPATH) || exit 1) > /dev/null 2>&1 && unset CDPATH || :

# Unset more variables known to interfere with behavior of common tools.
test ${CLICOLOR_FORCE+y} && ( (unset CLICOLOR_FORCE) || exit 1) > /dev/null 2>&1 && unset CLICOLOR_FORCE || :
test ${GREP_OPTIONS+y} && ( (unset GREP_OPTIONS) || exit 1) > /dev/null 2>&1 && unset GREP_OPTIONS || :

# Ensure that fds 0, 1, and 2 are open.
if (exec 3>&0) 2> /dev/null; then :; else exec 0< /dev/null; fi
if (exec 3>&1) 2> /dev/null; then :; else exec 1> /dev/null; fi
if (exec 3>&2)            ; then :; else exec 2> /dev/null; fi

# The user is always right.
if ${PATH_SEPARATOR+false} :; then
  PATH_SEPARATOR=:
  (PATH='/bin;/bin'; FPATH=${PATH}; sh -c :) > /dev/null 2>&1 && {
    # shellcheck disable=SC2030,SC2034
    (PATH='/bin:/bin'; FPATH=${PATH}; sh -c :) > /dev/null 2>&1 ||
      PATH_SEPARATOR=';'
  }
fi

# Shell Sanity Check
# This is a spy to detect "in the wild" shells that do not support shell
# functions correctly. It is based on the m4sh.at Autotest testcases.
(eval 'fn_return () { (exit $1); }
fn_success () { fn_return 0; }
fn_failure () { fn_return 1; }
fn_ret_success () { return 0; }
fn_ret_failure () { return 1; }
exitcode=0
fn_success || { exitcode=1; echo fn_success failed.; }
fn_failure && { exitcode=1; echo fn_failure succeeded.; }
fn_ret_success || { exitcode=1; echo fn_ret_success failed.; }
fn_ret_failure && { exitcode=1; echo fn_ret_failure succeeded.; }
( set x; fn_ret_success y && test x = "$1" ) ||
{ exitcode=1; echo positional parameters were not saved.; }
test x$exitcode = x0 || exit 1') >&2 ||
{ echo "shell doesn't support functions correctly" >&2; exit 1; }
# This is a spy to detect "in the wild" shells that do not support
# the newer $(...) form of command substitutions.
(eval 'blah=$(echo $(echo blah))
test x"$blah" = xblah') > /dev/null 2>&1 ||
{ echo "shell doesn't support newer substitutions '\$(...)'" >&2; exit 1; }
# Succeed if the currently executing shell supports 'test -x'
(eval "test -x / || exit 1") > /dev/null 2>&1 ||
{ echo "shell doesn't support 'test -x <file>'" >&2; exit 1; }

# Find who we are. Look in the path if we contain no directory separator.
var_me=
var_myself=
var_basedir=
var_sep=
var_prev=
var_ifs=$IFS
case $0 in
  *[\\/]* )
    IFS=/
    for var_me in $0
    do
      var_basedir=$var_basedir$var_prev
      var_prev=$var_sep$var_me
      var_sep=/
    done
    IFS=$var_ifs
    test "x$var_basedir" != x || { var_basedir=$var_sep; var_sep=;}
    ;;
  *)
    IFS=$PATH_SEPARATOR
    for var_basedir in $PATH
    do
      IFS=$var_ifs
      case $var_basedir in
        '') var_basedir=. var_sep=/ ;;
         /) var_sep= ;;
        */)
          var_prev=$var_basedir var_basedir= var_sep= IFS=/
          for var_prev in $var_prev
          do var_basedir=$var_basedir$var_sep$var_prev var_sep=/
          done
          IFS=$var_ifs ;;
        * ) var_sep=/ ;;
      esac
      { test -r "$var_basedir$var_sep$0" && var_me=$0 && break; } || :
      var_basedir=
      var_sep=
    done
    IFS=$var_ifs
    ;;
esac
var_myself=$var_basedir$var_sep$var_me
var_prev=; unset var_prev
var_sep=; unset var_sep
var_ifs=; unset var_ifs

# We did not find ourselves, most probably we were run as `sh COMMAND'
# in which case we are not to be found in the path.
test "x$var_myself" != x || var_myself=$0
test -f "$var_myself" ||
{ printf "%s\n" "$var_myself: error: cannot find myself; rerun with an absolute file name" >&2; exit 1; }
test -d "$var_basedir" ||
{ printf "%s\n" "$var_basedir: error: cannot find base directory; rerun with an absolute file name" >&2; exit 1; }

# Check if myself.lineno exists and is newer
case $var_myself in
  *.lineno) _var_can_reexec=no; export _var_can_reexec ;;
  *) : ;;
esac
test "${_var_can_reexec+y}" ||
test -f "${var_myself}.lineno" &&
test -x "${var_myself}.lineno" &&
d0=`stat -c %Y "$var_myself" 2>&1` &&
d1=`stat -c %Y "${var_myself}.lineno" 2>&1` &&
test "$d0" -lt "$d1" >/dev/null 2>/dev/null && {
  printf '%s\n' "loading ${var_myself}.lineno"
  unset 'var_basedir' 'var_me' 'd0' 'd1'
  # Ensure we don't try to do so again and fall in an infinite loop.
  _var_can_reexec=no; export _var_can_reexec
  # shellcheck disable=SC1090
  . "${var_myself}.lineno"
  exit
} || :
d0=; unset d0
d1=; unset d1

# Check if the shell supports LINENO, otherwise
# replace all $LINENO ocurrences by the line number.
(a=$LINENO ano=$LINENO
b=$LINENO bno=$LINENO
eval 'test "x$a'$_var_can_reexec'" != "x$b'$_var_can_reexec'" &&
test "x`expr $a'$_var_can_reexec' + 1`" = "x$b'$_var_can_reexec'"') 2> /dev/null || {
  test "${_var_can_reexec+y}" &&
  { echo "shell doesn't support LINENO" >&2; set +e; exit 1; } || :
  # Blame Lee E. McMahon (1931-1989) for sed's syntax.  :-)
  # shellcheck disable=SC1090
  sed -n '
    p
    /[$]LINENO/=
  ' <"$var_myself" | sed '
    s/[$]LINENO.*/&-/
    t lineno
    b
    :lineno
    N
    :loop
    s/[$]LINENO\([^abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_].*\n\)\(.*\)/\2\1\2/
    t loop
    s/-\n.*//
  ' > "${var_myself}.lineno" ||
  { printf "%s\n" "$var_me: error: cannot create '$var_myself.lineno'" >&2; set +e; exit 1; }
  # shellcheck disable=SC1090
  chmod +x "${var_myself}.lineno" ||
  # Ensure we don't try to do so again and fall in an infinite loop.
  _var_can_reexec=no; export _var_can_reexec
  # Don't try to exec as it changes $[0], causing all sort of problems
  # (the dirname of $[0] is not the place where we might find the
  # original and so on.  Autoconf is especially sensitive to this).
  # shellcheck disable=SC1090
  . "$var_myself.lineno"
  # Exit status is that of the last command.
  exit
}

#################################
## SHELL FUNCTIONS AND HELPERS ##
#################################

# fn_unset <VAR1> <VAR2>
# ---------------
# Portably unset VAR.
fn_unset ()
{
  while test "$#" -gt 0
  do eval "${1}=" && unset "${1}" && shift || return "$?"
  done
  return 0
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
  if test "$#" -gt 0 && test 0 -le "${1}"
  then fn_set_status "${1}"; exit "${1}"
  else fn_set_status 1; exit 1
  fi
} # fn_exit

# fn_is_executable <FILE>
# -----------------------
# Test if FILE is an executable regular file.
fn_is_executable ()
{
  test "$#" -eq 1 && test -f "${1}" && test -x "${1}"
} # fn_is_executable

# fn_arith <VARNAME> [..EXPRESSION]
# ------------------
# Perform arithmetic evaluation on the ARGs, and store the result in the
# first argument $1. Take advantage of shells that can avoid forks. The
# arguments must be portable across $(()) and expr.
if (eval "test \$(( 1 + 1 )) = 2") 2> /dev/null
then :
fn_arith ()
{
  eval "shift && ${1}=\$(( \$* ))"
}
else :
fn_arith ()
{
  eval "shift && ${1}="'`expr "$@" || test $? -eq 1`'
}
fi # fn_arith

# fn_append <VAR> <VALUE>
# ----------------------
# Append the text in VALUE to the end of the definition contained in VAR. Take
# advantage of any shell optimizations that allow amortized linear growth over
# repeated appends, instead of the typical quadratic growth present in naive
# implementations.
if (eval "as_var=1; as_var+=2; test x\$as_var = x12") 2> /dev/null
then eval 'fn_append ()
{
  eval "${1}+=\${2}"
}'
else fn_append ()
{
  eval "${1}=\"\$${1}\${2}\""
}
fi # fn_append

# fn_is_uint <VALUE>
# ----------------------------------------
# Check if provided <VALUE> in an unsigned integer
fn_is_uint ()
{
  test "$#" -gt 0 || { printf '%s\n' "fn_is_uint:$LINENO: no args" >&2; return 127; }
  while test "$#" -gt 1
  do
    fn_is_uint "${1}"|| return "$?"
    shift || { printf '%s\n' "fn_is_uint:$LINENO: shift failed" >&2; return 125; }
  done
  test "x${1}" != x > /dev/null 2>&1 || return 2
  case $1 in
    [0123456789]) return 0 ;;
    [123456789]*[0123456789]) : ;;
    *) return 1 ;;
  esac
  test 0 -le "${1}" > /dev/null 2>&1
} # fn_is_uint

# fn_locals_declare <VAR1> <VAR2> ... <VARN>
# ----------------------
# Portably define local variables, behaves like 'local <varname>', except
# it also can be used outside function body. Values are store variable in
# a global stack prefixed with `_var_local_$STACKSIZE`.
# Use `fn_locals_declare <varname>` to declare one or more locals
# Use `fn_locals_release` to release locals and if needed restored previous
# global values.
# IMPORTANT: never declare or overwrite any variable that matches the pattern
# `_var_local_*`, those are reserved for `fn_locals_declare` and `fn_locals_release`
# usage only.
_var_local_='_var_local_' # Change this value to change the stack prefix.
eval "if (eval 'test \$(( 1 + 1 )) = 2') 2> /dev/null
then ${_var_local_}='${_var_local_}=\$(( \${${_var_local_}} + 1 ))'
else ${_var_local_}='${_var_local_}=\`expr \"1\" \"+\" \"\${${_var_local_}}\" || test \$? -eq 1\`'
fi
eval \"fn_locals_declare ()
{
  test \\\"\\\$#\\\" -gt 0 ||
  { printf \\\"%s\\\\n\\\" \\\"[ERROR] fn_locals_declare: no variables provided\\\" >&2; fn_exit 127; }
  if test \\\"\\\${${_var_local_}+y}\\\" && test \\\"\\\${${_var_local_}}\\\" -ge 0 2> /dev/null
  then
    set x \\\"\\\${${_var_local_}}\\\" \\\"\\\$@\\\" && shift || fn_exit 125
    \${${_var_local_}} || fn_exit 125
    eval \\\"${_var_local_}\\\${${_var_local_}}='${_var_local_}=\\\${1};unset \\\\\\\"${_var_local_}\\\${${_var_local_}}\\\\\\\"'\\\" && shift || fn_exit 125
  else
    ${_var_local_}=0
    eval \\\"${_var_local_}\\\${${_var_local_}}='unset \\\\\\\"${_var_local_}\\\\\\\" \\\\\\\"${_var_local_}\\\${${_var_local_}}\\\\\\\"'\\\" || fn_exit 125
  fi
  while test \\\"\\\$#\\\" -gt 0
  do
    if eval \\\"test \\\\\\\${\\\$1+y}\\\" 2> /dev/null
    then
      test \\\"x\\\${${_var_local_}}\\\" != \\\"x${_var_local_}\\\" || { shift || fn_exit 125; continue; }
      { set x \\\"\\\${${_var_local_}}\\\" \\\"\\\$@\\\" && shift; } || fn_exit 125
      \${${_var_local_}} || fn_exit 125
      eval \\\"${_var_local_}\\\${${_var_local_}}=\\\\\\\"\\\${2}=\\\\\\\\\\\\\\\$${_var_local_}\\\${1};\\\\\\\${${_var_local_}\\\${1}} \\\\\\\\\\\\\\\"${_var_local_}\\\${${_var_local_}}\\\\\\\\\\\\\\\"\\\\\\\" &&
      ${_var_local_}\\\${1}=\\\\\\\${\\\${2}} &&
      unset '\\\${2}'\\\" || fn_exit 125
      { shift && shift; } || fn_exit 125
    else
      eval \\\"${_var_local_}\\\${${_var_local_}}=\\\\\\\"\\\${1}=;\\\\\\\${${_var_local_}\\\${${_var_local_}}} \\\\\\\\\\\\\\\"\\\${1}\\\\\\\\\\\\\\\"\\\\\\\"\\\" && shift || fn_exit 125;
    fi
  done
}

fn_locals_release ()
{
  { test \\\"\\\${${_var_local_}+y}\\\" = y && test \\\"x\\\${${_var_local_}}\\\" != x; } ||
  { printf \\\"%s\\\\n\\\" \\\"[ERROR] fn_locals_release: no corresponding 'fn_locals_declare'\\\" >&2; fn_exit 127; }
  eval \\\"eval \\\\\\\"\\\\\\\${${_var_local_}\\\${${_var_local_}}}\\\\\\\"\\\" || fn_exit 127
  test \\\"\\\$#\\\" -eq 0 || return \\\"\\\$1\\\"
}

${_var_local_}=
unset \\\"${_var_local_}\\\"\"" ||
{ echo "failed declare functions 'fn_locals_declare' and 'fn_locals_release' $?" >&2; exit 1; }

## BEGIN COLORS ##
# Colors are hardcode in the function body using eval, so they doesn't need to detect
# colors support for every call, neither rely on global variables for storing colors,
# which is desirable for functions like "fn_abort" which must be infallible. Notice isn't
# possible to change the colors without redefining the function.
fn_locals_declare 'var_colors' 'var_bold' 'var_red' 'var_green' 'var_blue' 'var_yellow' 'var_cyan' 'var_reset'

# Detect colors support
test -t 1 2> /dev/null &&
var_colors=`tput colors 2>&1` &&
test 8 -le "${var_colors}" > /dev/null 2>&1 &&
var_bold=`tput bold 2>&1` &&
var_red=`tput setaf 1 2>&1` &&
var_green=`tput setaf 2 2>&1` &&
var_blue=`tput setaf 4 2>&1` &&
var_yellow=`tput setaf 3 2>&1` &&
var_cyan=`tput setaf 6 2>&1` &&
var_reset=`tput sgr0 2>&1` ||
{ var_bold= var_red= var_green= var_blue= var_yellow= var_cyan= var_reset=; }

# fn_printf FMT ...ARGS
# ----------------------------------------
# Extend printf escape sequences to support colors.
# Colors Escapes:
# @n: bold
# @r: red     | @R: red + bold
# @g: green   | @G: green + bold
# @b: blue    | @B: blue + bold
# @y: yellow  | @Y: yellow + bold
# @c: cyan    | @C: cyan + bold
#
# Example usage:
# - fn_printf '@E @w %s @b @W @e @w\n' 'all' 'colors' 'mixed' 'in' 'the' 'same' 'text'
eval "fn_printf ()
{
  test \"x\${IFS}x\" = 'x${IFS}x' || { (IFS='$IFS';fn_printf \"\$@\";) || return \"\$?\"; return 0; };
  test \"\$#\" -gt 0 || { printf; return \"\$?\"; }
  set x 'eval printf \"x%sx\" \"\$3\" | sed \"\$2\" 2> /dev/null' '{
  s/'\\''/'\\''\\\\'\\'\\''/g
  s/[\\\\\$\`\"]/\\\\&/g
  s/@[RGBYCrgbycn]/&%s\\\${7}/g
  s/@[RGBYCn]/\\\${1}&/g
  s/@n//g
  s/@[Rr]/\\\${2}/g
  s/@[Gg]/\\\${3}/g
  s/@[Bb]/\\\${4}/g
  s/@[Yy]/\\\${5}/g
  s/@[Cc]/\\\${6}/g
  s/'\\''/'\\''\\\\'\\'\\''/g
  1s/^x/shift \\&\\& shift \\&\\& shift \\&\\& set x '\\'\\\"\\''\\\\'\\'\\''/
  \$s/x\$/'\\''\\\\'\\'\\'\\\"\\'' \\\"\\\$@\\\" \\&\\& shift/
}' \"\$@\" && shift || return 125
  eval \"\`\$1\`\" || return 125
  set x '${var_bold}' '${var_red}' '${var_green}' '${var_blue}' '${var_yellow}' '${var_cyan}' '${var_reset}' \"\$@\" && shift || return 125
  eval \"eval 'shift && shift && shift && shift && shift && shift && shift && shift && set x '\$8' \\\"\\\$@\\\" && shift'\" || return 125
  printf \"\$@\"
}" || { printf '%s\n' "failed to define function 'fn_printf' status $?" >&2; exit 1; }

# fn_abort <STATUS> <LINENO> <MSG>
# ----------------------------------------
# Output "`basename $0`: error: ERROR" to stderr. If LINENO and LOG_FD are
# provided, also output the error to LOG_FD, referencing LINENO. Then exit the
# script with STATUS, using 1 if that was 0.
eval "fn_abort ()
{
  set +e
  var_nl='${var_nl}'
  IFS='${IFS}'
  var_message=
  :; { test \"\$#\" -gt 0 && var_status=\$1; } || { test \${var_status+y} || var_status=1; }
  :; { test \"\$#\" -gt 1 && var_lineno=\$2; } || { test \${var_lineno+y} || var_lineno=\$LINENO; }
  test \"\$#\" -lt 3 || { var_message=\$3; }
  { test -n \"\${var_status}\" && test \"\${var_status}\" -gt 0 2> /dev/null; } || var_status=1
  { test -n \"\${var_lineno}\" && test \"\${var_lineno}\" -gt 0 2> /dev/null; } || var_lineno=
  printf '%s %s%s%s %s\\n' '${var_bold}${var_red}[ERROR]${var_reset}' \"${var_red}\${var_myself}:\${var_status}:${var_reset}\" \"${var_bold}${var_red}\${var_lineno}${var_reset}\" '${var_red}:${var_reset}' \"\${var_message}\" >&2
  fn_set_status \"\${var_status}\"
  exit \"\${var_status}\"
}" # fn_abort
fn_locals_release
## END COLORS ##

# usage: path_lookup <PROGRAMN_NAME>
# ----------------------
# Portably find PROGRAMN in $PATH printing its absolute path, this function
# solves some pitfalls from `command -v <programn>` and `which <programn>` as
# both can't find a valid filepath when the programn's name conflicts with
# existing shell builtin such as echo, test, command, etc. This function always
# prints a valid absolute filepath to an executable file, otherwise fails.
fn_path_lookup ()
{
  test "$#" -gt 0  || { echo "fn_path_lookup: missing operand" >&2; return 127; }
  test "$#" -lt 2  || { echo "fn_path_lookup: extra operand '$2'" >&2; return 127; }
  test "${PATH+y}" || { echo "fn_path_lookup: variable 'PATH' is undefined" >&2; return 127; }
  test -n "${PATH}"  || { printf '%s\n' "command '$1' not found in \$PATH" >&2; return 1; }
  fn_locals_declare var_dir var_sep var_aux var_ifs var_cmd var_opt
  case $- in
    *f*)
      var_opt=
      ;;
    *)
      var_opt=f
      set -f 2> /dev/null || { fn_locals_release "$?"; printf '%s\n' "fn_path_lookup:$LINENO
command 'set -f' failed with status $?"; fn_exit 1; }
      ;;
  esac
  var_dir=
  var_sep=
  var_aux=
  var_cmd=$1
  var_ifs=$IFS
  IFS=$PATH_SEPARATOR
  set x $PATH || { fn_locals_release "$?"; printf '%s\n' "fn_path_lookup:$LINENO
command 'set x \$PATH' failed with status $?"; fn_exit 1; }
  IFS=$var_ifs
  shift || { fn_locals_release "$?"; printf '%s\n' "fn_path_lookup:$LINENO
command 'shift' failed with status $?"; fn_exit 1; }
  while test "$#" -gt 0
  do
    case $1 in
      '')
        var_dir=.
        var_sep=/
        ;;
      /)
        var_dir=/
        var_sep=
        ;;
      */)
        var_aux=
        var_dir=
        var_sep=
        IFS=/
        for var_aux in $1
        do var_dir=$var_dir$var_sep$var_aux var_sep=/
        done
        IFS=$var_ifs
        ;;
      * )
        var_dir=$1
        var_sep=/
        ;;
    esac
    var_aux=$var_dir$var_sep$var_cmd
    if test -r "$var_dir" && test -f "$var_aux" && test -x "$var_aux"
    then var_cmd=$var_aux; break
    else :
    fi
    var_dir=
    var_sep=
    var_aux=
    shift || { fn_locals_release "$?"; printf '%s\n' "fn_path_lookup:$LINENO
command 'shift' failed with status $?"; fn_exit 1; }
  done
  test -z "$var_opt" || set "+$var_opt" || { fn_locals_release "$?"; printf '%s\n' "fn_path_lookup:$LINENO
command \`set '+$var_opt'\` failed with status $?"; fn_exit 1; }
  if test "$#" -gt 0
  then printf '%s' "$var_cmd"; fn_locals_release 0; return 0
  else printf '%s\n' "command '$var_cmd' not found in \$PATH" >&2 ; fn_locals_release 1; return 1
  fi
} # fn_path_lookup

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

# fn_sanitize_filename <STRING>
# ---------------
# replace non-alphanumeric characteres by '-'
fn_sanitize_filename ()
{
  # Avoid depending upon Character Ranges.
  printf '%s' "${1}" | sed 'y%*+%pp%;s%[^_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]%-%g'
} # fn_sanitize_filename

# fn_single_quote [...STRINGS]
# ---------------
# wraps each string in single quotes.
fn_single_quote ()
{
  while test "$#" -gt 0
  do
    # 'x<STRING>x' forces 'sed' to preserve leading and trailing spaces.
    printf 'x%sx' "${1}" | LC_ALL=C sed "{
      s/'/'\\\\''/g
      1s/^x/'/
      \$s/x\$/'/
    }" || return "$?"
    test "$#" -gt 1 || return 0
    printf ' ' && shift || return "$?"
  done
} # fn_single_quote

# fn_dquote_escape [...STRINGS]
# ----------------------
# escape double quotes special characters
fn_dquote_escape ()
{
  while test "$#" -gt 0
  do
    # 'x<STRING>x' forces 'sed' to preserve leading and trailing spaces.
    printf 'x%sx' "${1}" | LC_ALL=C sed '{
      1s/^x//
      $s/x$//
      s/[\\$`"]/\\&/g
    }' || return "$?"
    test "$#" -gt 1 || return 0
    printf ' ' && shift || return "$?"
  done
} # fn_dquote_escape

# fn_assign_args <VARNAME> [...ARGS]
# ----------------------
# Escape and quote the provided arguments, then assign it
# to VARNAME
fn_quote_assign ()
{
  test "$#" -gt 0 || return 127;
  if test "$#" -gt 1
  then eval "shift && ${1}=\`fn_quote_args \"\$@\"\`" || return 125
  else eval "${1}=" || return 125
  fi
} # fn_assign_args

# fn_eval_assign <VARNAME> <COMMAND> [...ARGS]
# ----------------------
# Escape and quote the provided arguments, then assign it
# to VARNAME
fn_eval_assign ()
{
  test "$#" -gt 1 || return 127;
  test "x$2" != 'xfn_eval_assign' || return 127;
  fn_quote_assign "$@" || return "$?"
  eval "set x '${1}' \"\${${1}}\" && shift" || return 125
  fn_quote_assign "${1}" "printf x && ${2} && printf x" || return "$?"
  eval "set x '${1}' \"\${${1}}\" && shift" || return 125
  fn_quote_assign "${1}" '{
    s/[\\$`"]/\\&/g
    1s/^x/"/
    $s/x$/"/
  }' || return "$?"
  eval "${1}=\"eval \${2} | LANGUAGE=C LC_ALL=C sed \${${1}}\""
  eval "set x '${1}' \"\${${1}}\" && shift" || return 125
  eval "${1}=\`eval \"\$2\"\` && eval \"${1}=\$${1}\"" || return 125
} # fn_eval_assign

# fn_repeat <text> <n>
# ---------------
# print `text` `n` times
fn_repeat ()
{
  test "$#" -eq 2 && test "x${1}" != x && test 0 -le "${2}" || return 127
  fn_locals_declare 'count' 'double' 'text' || return "$?"
  text=
  count=0
  double=${1}
  fn_arith count 0 '+' "${2}" || { fn_locals_release; return "$?"; }
  while test "${count}" -gt 0
  do
    case $count in
      *[13579]) fn_append 'text' "${double}" || { fn_locals_release; return "$?"; } ;;
      *) : ;;
    esac
    fn_arith count "${count}" '/' 2 &&
    fn_append 'double' "${double}" || { fn_locals_release; return "$?"; }
  done
  printf '%s' "${text}"
  fn_locals_release || return "$?"
} # fn_repeat

# fn_fmt_command <command> [args...]
# ---------------
# break a command in multiple lines if it doesn't fit in 80 columns.
fn_fmt_command ()
{
  v="$*"
  if test "${#v}" -gt 80
  then
    if test "$#" -gt 1
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
  fn_locals_declare 'value' 'as_val'
  value=
  as_val=
  fn_as_arith value "${#2}" '+' 2
  fn_as_arith as_val 0 '+' "${3}"
  if test "${value}" -lt "${as_val}"; then
    fn_as_arith as_val "${3}" '-' "${#2}"
    fn_as_arith as_val "${as_val}" '-' 2
    fn_as_arith as_val "${as_val}" '/' 2
    value="$(fn_repeat "${1}" "${as_val}")"
    fn_as_arith as_val "${#2}" '%' 2
    if test "${as_val}" = 1
    then printf '%s %s %s\n' "${value}" "${2}" "${value}${1}"
    else printf '%s %s %s\n' "${value}" "${2}" "${value}"
    fi
  else
    printf '%s\n' "${2}"
  fi
  fn_locals_release
} # fn_show_header

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
  printf '%s' "$(fn_single_quote "${1}" 2>&1 || true)"
  shift
  for v; do
    # shellcheck disable=SC2310
    printf ' %s' "$(fn_single_quote "${v}" 2>&1 || true)";
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

# fn_check_varname <VARNAME>
# ----------------------
# Check if <VARNAME> is a valid shell variable name
fn_check_varname ()
{
  test "$#" -gt 0 || fn_abort 127 "${var_lineno-$LINENO}" "fn_check_varname:$LINENO: no arguments"
  test "x${1}" != 'x' || return 1
  # Avoid depending upon Character Ranges.
  # https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.72/html_node/Special-Shell-Variables.html
  case $1 in
    [0123456789_]) return 1 ;;
    [_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*) : ;;
    *) return 1 ;;
  esac
  LC_ALL=C expr "X${1}X" ':' 'X[_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]*X' > /dev/null 2>&1
} # fn_check_varname

# fn_detect_arch [VARNAME]
# ---------------
# detect host architecture
fn_detect_arch ()
{
  # Validade parameters and declare locals
  if test "$#" -gt 0
  then
    test "$#" -eq 1 || { printf '%s\n' "fn_check_varname:$LINENO: extra operand '${2}'" >&2; return 127; }
    test "x${1}" != x || { printf '%s\n' "fn_check_varname:$LINENO: variable name is empty" >&2; return 127; }
    fn_check_varname "${1}" || { printf '%s\n' "fn_check_varname:$LINENO: invalid variable name '${1}'" >&2; return 127; }
    case $1 in
      cmd_dpkg) fn_locals_declare 'cmd_uname' 'var_arch' ;;
      cmd_uname) fn_locals_declare 'cmd_dpkg' 'var_arch' ;;
      var_arch) fn_locals_declare 'cmd_dpkg' 'cmd_uname' ;;
      *) fn_locals_declare 'cmd_dpkg' 'cmd_uname' 'var_arch' ;;
    esac
  else fn_locals_declare 'cmd_dpkg' 'cmd_uname' 'var_arch'
  fi

  # Detect architecture using `dpkg` or `uname`
  cmd_dpkg= cmd_uname= var_arch=
  { cmd_dpkg=`fn_path_lookup dpkg 2>&1` && var_arch=`"${cmd_dpkg}" --print-architecture 2>&1`; } ||
  { cmd_uname=`fn_path_lookup uname 2>&1` && var_arch=`"${cmd_uname}" -m 2>&1`; } ||
  { printf '%s\n%s\n%s\n' "${cmd_dpkg}" "${cmd_uname}" "${var_arch}" >&2; fn_locals_release; return 1; }

  # Use LLVM architecture naming convention
  case $var_arch in
    x86_64|amd64)         var_arch='x86_64'    ;;
    x86|i*86)             var_arch='x86'       ;;
    aarch64|arm64)        var_arch='aarch64'   ;;
    arm32|armv6l|armv7l)  var_arch='arm'       ;;
    riscv64*)             var_arch='riscv64gc' ;;
    ppc64le|rs6000)       var_arch='ppc64le'   ;;
    sun4m|sparc)          var_arch='sparc'     ;;
    *)
      printf '%s\n' "unknown architecture '${var_arch}'" >&2
      fn_locals_release
      return 1
      ;;
  esac

  if test "$#" -eq 0
  then printf '%s\n' "${var_arch}"
  else
    eval "${1}=\${var_arch}" ||
    { printf '%s\n' "fn_check_varname:$LINENO: eval failed with status $?" >&2; fn_locals_release; return 125; }
  fi
  fn_locals_release
} # fn_detect_arch

# fn_current_dir
# ---------------
# retrieve current directory
# shellcheck disable=SC2329
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

# fn_is_directory <PATH> <LINENO>
# ----------------------------------------
# Check if the provided PATH is a directory and is readable by current user.
fn_is_directory ()
{
  test "$#" -gt 0 || fn_abort 127 "${var_lineno-$LINENO}" "fn_is_directory:$LINENO: missing operand"
  test "$#" -gt 1 || fn_abort 127 "${var_lineno-$LINENO}" "fn_is_directory:$LINENO: missing LINENO"
  test "$#" -eq 2 || fn_abort 127 "${var_lineno-$LINENO}" "fn_is_directory:$LINENO: extra operand '${3}'"
  fn_is_uint "${2}" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_is_directory:$LINENO: invalid LINENO '${2}'"
  test "x${1}" != x || fn_abort 127 "${2}" "fn_is_directory:$LINENO: provided path is empty"
  test -e "${1}" || fn_abort 1 "${2}" "directory not found '${1}'"
  test -d "${1}" || fn_abort 1 "${2}" "not a directory '${1}'"
  test -r "${1}" || fn_abort 1 "${2}" "user doesn't have permission to read the directory '${1}'"
} # fn_is_directory

# fn_is_file <PATH> <LINENO>
# ----------------------------------------
# Check if the provided PATH is a file and is readable by current user.
fn_is_file ()
{
  test "$#" -gt 0 || fn_abort 127 "${var_lineno-$LINENO}" "fn_is_file:$LINENO: missing operand"
  test "$#" -lt 3 || fn_abort 127 "${var_lineno-$LINENO}" "fn_is_file:$LINENO: extra operand '${3}'"
  if test "$#" -eq 1
  then :
    set x "${1}" "${var_lineno-$LINENO}" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_is_file:$LINENO: builtin command failed
set x '${1}' '${var_lineno-$LINENO}'"
    shift || fn_abort "$?" "${var_lineno-$LINENO}" "fn_is_file:$LINENO: 'shift' command failed"
  else :
  fi
  fn_is_uint "${2}" || fn_abort 127 "${var_lineno-$LINENO}" "fn_is_file:$LINENO: invalid lineno '${2}'"
  test -e "$1" || fn_abort 1 "${2}" "file not found '${1}'"
  test -f "$1" || fn_abort 1 "${2}" "not a file '${1}'"
  test -r "$1" || fn_abort 1 "${2}" "no read permission of file '${1}'"
} # fn_is_directory

# fn_var_copy <DEST_VARNAME> <SRC_VARNAME>
# ----------------------
# Copy the value from SRC_VARNAME to DEST_VARNAME
# OBS: abort if SRC_VARNAME is undefined
fn_var_copy ()
{
  test "$#" -gt 0 || fn_abort 1 "${var_lineno-$LINENO}" "fn_var_copy:$LINENO: no arguments"
  test "$#" -gt 1 || fn_abort 1 "${var_lineno-$LINENO}" "fn_var_copy:$LINENO: missing SRC_VARNAME"
  test "$#" -eq 2 || fn_abort 1 "${var_lineno-$LINENO}" "fn_var_copy:$LINENO: extra operand '$3'"
  # Check parameters
  test "x${1}" != 'x' || fn_abort 1 "${var_lineno-$LINENO}" "fn_var_copy:$LINENO: DEST_VARNAME is empty"
  test "x${2}" != 'x' || fn_abort 1 "${var_lineno-$LINENO}" "fn_var_copy:$LINENO: SRC_VARNAME is empty"
  fn_check_varname "${1}" || fn_abort 1 "${var_lineno-$LINENO}" "fn_var_copy:$LINENO: invalid dest variable name '${1}'"
  fn_check_varname "${2}" || fn_abort 1 "${var_lineno-$LINENO}" "fn_var_copy:$LINENO: invalid src variable name '${2}'"
  eval "test \${${2}+y}" || fn_abort 1 "${var_lineno-$LINENO}" "fn_var_copy:$LINENO: src variable '$2' is undefined"
  eval "${1}=\${${2}}" || fn_abort 1 "${var_lineno-$LINENO}" "fn_var_copy:$LINENO: failed to assign '$2' to '$1'"
}

# fn_var_exists [..VARNAMES]
# ----------------------------------------
# Returns status 0 if all provided VARNAMES are defined and non empty.
fn_var_exists ()
{
  while test "$#" -gt 0; do
    # Check varname
    fn_check_varname "${1}" || return "$?"
    # Return 1 if variable is undefined
    eval "test \"\${${1}+y}\"" || return 1
    # Return 2 if variable is empty
    eval "test \"x\${${1}}\" != 'x'" || return 2
    # Return if there's no more variables
    test "$#" -gt 1 || return 0
    shift 2>/dev/null || fn_abort 1 "${var_lineno-$LINENO}" "fn_var_exists:$LINENO: shift failed $?"
  done
  fn_abort 1 "${var_lineno-$LINENO}" "fn_var_exists:$LINENO: no arguments"
} # fn_var_exists

# fn_stack_exists <STACKNAME>
# ----------------------
# Check if the STACKNAME exists and is valid, returns status 0 if stack
# exists and is valid, status 1 if doesn't exists, exit if stack is invalid.
fn_stack_exists ()
{
  test "$#" -gt 0 || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_exists:$LINENO: no arguments"
  test "$#" -eq 1 || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_exists:$LINENO: extra operand '$2'"
  # Check parameters
  test "x${1}" != 'x' || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_exists:$LINENO: STACKNAME is empty"
  fn_check_varname "${1}" || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_exists:$LINENO: invalid stack name '${1}'"
  # check if the stack is empty
  eval "fn_var_exists '${1}_begin' '${1}_end'" || return 1
  # check if the stack is valid
  eval "fn_is_uint \"\${${1}_begin}\"" || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_exists:$LINENO: '${1}_begin' is not an integer"
  eval "fn_is_uint \"\${${1}_end}\"" || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_exists:$LINENO: '${1}_end' is not an integer"
  eval "test \"\${${1}_begin}\" -lt \"\${${1}_end}\"" || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_exists:$LINENO: '${1}_begin' >= '${1}_end'"
  eval "test \"\${${1}_begin}\" -ge 0" || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_exists:$LINENO: '${1}_begin' < 0"
} # fn_stack_exists

# fn_stack_push <STACKNAME> [...VALUES]
# ----------------------
# push a value into the stack <STACKNAME>, if the stack doesn't exists, create one.
fn_stack_push ()
{
  test "$#" -gt 0 || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_push:$LINENO: no arguments"
  # check stack exists
  fn_stack_exists "${1}" ||
  { eval "${1}_begin=0;${1}_end=0" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_push:$LINENO: failed to initialize stack '${1}_begin' and '${1}_end'"; }
  # check values
  test "$#" -gt 1 || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_push:$LINENO: no values provided for stack '${1}'"
  # check stack exists
  fn_locals_declare "var_name" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_push:$LINENO: fn_locals_declare failed"
  var_name=$1
  shift || fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_push:$LINENO: failed to increment '${1}_end'"
  while test "$#" -gt 0; do
    # assign value to stack
    eval "eval \"${var_name}\${${var_name}_end}=\\\"\\\${1}\\\"\"" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_push:$LINENO: failed assign value '${var_name}' to end of stack"
    # increment stack level
    eval "fn_arith '${var_name}_end' '1' '+' \"\${${var_name}_end}\"" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_push:$LINENO: failed to increment '${var_name}_end'"
    # continue or return
    test "$#" -gt 1 || { fn_locals_release; return 0; }
    shift 2> /dev/null || fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_push:$LINENO: shift failed with status $?"
  done
  fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_push:$LINENO: unreachable"
} # fn_stack_push

# fn_stack_pop_front <STACKNAME> <INDEX>
# ----------------------
# pops a value from the stack and assign it to <VAR>
fn_stack_pop_front ()
{
  test "$#" -gt 0 || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_pop_front:$LINENO: no arguments"
  test "x${1}" != 'x' || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_pop_front:$LINENO: stack name cannot be empty"
  test "$#" -gt 1 || { set x "$1" "$1" && shift; } || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_pop_front:$LINENO: builtin 'set' failed"
  test "x${2}" != 'x' || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_pop_front:$LINENO: variable name cannot be empty"
  test "$#" -eq 2 || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_pop_front:$LINENO: extra operand '$3'"
  fn_stack_exists "$1" || return 1
  # Copy the value of DEST=STACK[BEGIN]
  eval "fn_var_copy '${2}' \"${1}\${${1}_begin}\"" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_pop_front:$LINENO: eval failed"
  # unset STACK[BEGIN]
  eval "eval \"unset '${1}\${${1}_begin}'\"" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_pop_front:$LINENO: failed to unset '${1}' at '${1}_begin'"
  # increment begin of the stack
  eval "fn_arith '${1}_begin' '1' '+' \"\${${1}_begin}\"" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_pop_front:$LINENO: failed to increment '${1}_beign'"
  # check if the stack is empty
  eval "test \"\${${1}_begin}\" -lt \"\${${1}_end}\"" ||
  { eval "unset '${1}_begin' '${1}_end'" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_pop_front:$LINENO: failed to unset '${1}_beign' and '${1}_end'"; }
} # fn_stack_pop_front

# fn_stack_pop_back <STACKNAME>
# ----------------------
# pops a value from the stack and assign it to <VAR>
fn_stack_pop_back ()
{
  test "$#" -gt 0 || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_pop_back:$LINENO: no arguments"
  test "x${1}" != 'x' || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_pop_back:$LINENO: stack name cannot be empty"
  test "$#" -gt 1 || { set x "$1" "$1" && shift; } || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_pop_back:$LINENO: builtin 'set' failed"
  test "x${2}" != 'x' || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_pop_back:$LINENO: variable name cannot be empty"
  test "$#" -eq 2 || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_pop_back:$LINENO: extra operand '$3'"
  fn_stack_exists "$1" || return 1
  # decrement end of the stack
  eval "fn_arith '${1}_end' \"\${${1}_end}\" '-' '1'" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_pop_back:$LINENO: failed to decrement '${1}_end'"
  # Copy the value of DEST=STACK[BEGIN]
  eval "fn_var_copy '${2}' \"${1}\${${1}_end}\"" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_pop_back:$LINENO: eval failed"
  # unset STACK[BEGIN]
  eval "eval \"unset '${1}\${${1}_end}'\"" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_pop_back:$LINENO: failed to unset '${1}' at '${1}_end'"
  # check if the stack is empty
  eval "test \"\${${1}_begin}\" -lt \"\${${1}_end}\"" ||
  { eval "unset '${1}_begin' '${1}_end'" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_pop_back:$LINENO: failed to unset '${1}_beign' and '${1}_end'"; }
} # fn_stack_pop_back

# fn_stack_length <STACKNAME> [DEST=$STACKNAME]
# ----------------------
# assigns the length of the stack STACKNAME to DEST
fn_stack_length ()
{
  test "$#" -gt 0 || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_length:$LINENO: no arguments"
  test "x${1}" != 'x' || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_length:$LINENO: stack name cannot be empty"
  test "$#" -gt 1 || { set x "$1" "$1" && shift; } || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_length:$LINENO: builtin 'set' failed"
  test "x${2}" != 'x' || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_length:$LINENO: variable name cannot be empty"
  test "$#" -eq 2 || fn_abort 1 "${var_lineno-$LINENO}" "fn_stack_length:$LINENO: extra operand '$3'"
  fn_stack_exists "$1" || { eval "${2}=0" && return 0 || return "$?"; }
  # decrement end of the stack
  eval "fn_arith '${2}' \"\${${1}_end}\" '-' \"\${${1}_begin}\"" ||
  fn_abort "$?" "${var_lineno-$LINENO}" "fn_stack_length:$LINENO: failed to compute stack length'"
} # fn_stack_length

# fn_cd <DIRECTORY> <LINENO>
# ----------------------
# Change to <DIRECTORY> only if it exists and is readable.
# Use this method over pure `cd` for display a descriptive
# error message when the directory doesn't exists.
fn_cd ()
{
  test "$#" -gt 0 || fn_abort 127 "${var_lineno-$LINENO}" "fn_cd:$LINENO: no arguments"
  test "$#" -gt 1 || fn_abort 127 "${var_lineno-$LINENO}" "fn_cd:$LINENO: LINENO is missing"
  test "$#" -eq 2 || fn_abort 127 "${var_lineno-$LINENO}" "fn_cd:$LINENO: extra operand '$3'"
  fn_is_uint "${2}" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_cd:$LINENO: invalid LINENO '$2'"
  test "x${1}" != 'x' || fn_abort 127 "${2}" "fn_cd:$LINENO: cannot change to empty string"
  case $1 in
    .|./)
      fn_locals_declare 'var_current_directory'
      var_current_directory=
      fn_current_dir 'var_current_directory' "${2}"
      fn_exec "$LINENO" cd "${var_current_directory}"
      fn_locals_release
      ;;
    *)
      fn_is_directory "${1}" "${2}"
      fn_exec "$LINENO" cd "${1}"
      ;;
  esac
} # fn_cd

# _fn_exec_print <VARNAME> <OUTPUT>
# ----------------------
# TODO
_fn_exec_output()
{
  { test "$#" -eq 2 && test "x${2}" != x; } || return 0
  test "x${2}" != "x''" || eval "${1}=" || return 0
  eval "set x '${1}' ${2}" 2> /dev/null || return 0
  eval "${2}=\"--------------------------------------------------------------------------------
\${3}================================================================================\"" || :
} # _fn_exec_print

# _fn_exec <VARNAME> <COMMAND> [...ARGUMENTS]
# ----------------------
# TODO
_fn_exec()
{
  var_status=0
  printf x
  "$@" 2>&1 || var_status=$?
  printf x
  fn_set_status "${var_status}"
  return "${var_status}"
} # _fn_exec

# fn_ifs_split <VARNAME> <IFS> [...ARGS]
# ----------------------
# Check if <VARNAME> is a valid shell variable name
fn_ifs_split ()
{
  if test "$#" -gt 3
  then
    fn_locals_declare 'var_fn_ifs_split_result' 'var_fn_ifs_split_value' 'var_fn_ifs_split_varname' 'var_fn_ifs_split_ifs'
    var_fn_ifs_split_result=
    var_fn_ifs_split_value=
    var_fn_ifs_split_varname=$1
    var_fn_ifs_split_ifs=$2
    { shift && shift; } || {
      var_fn_ifs_split_value=$?
      printf '%s\n' "fn_ifs_split:$LINENO: builtin 'shift' failed ${var_fn_ifs_split_value}" >&2
      fn_locals_release "$var_fn_ifs_split_value" || return "$?"
      return 125;
    }
    while test "$#" -gt 0
    do
      var_fn_ifs_split_value=
      fn_ifs_split 'var_fn_ifs_split_value' "${var_fn_ifs_split_ifs}" "${1}" || { fn_locals_release "$?" || return "$?"; return 125; }
      shift || {
        var_fn_ifs_split_value=$?
        printf '%s\n' "fn_ifs_split:$LINENO: builtin 'shift' failed ${var_fn_ifs_split_value}" >&2
        fn_locals_release "$var_fn_ifs_split_value" || return "$?"
        return 125;
      }
      if test "$#" -gt 0
      then var_fn_ifs_split_result="${var_fn_ifs_split_result}${var_fn_ifs_split_value} "
      else var_fn_ifs_split_result="${var_fn_ifs_split_result}${var_fn_ifs_split_value}"
      fi
    done
    set x "${var_fn_ifs_split_result}" || {
      var_fn_ifs_split_value=$?
      printf '%s\n' "fn_ifs_split:$LINENO: builtin 'shift' failed ${var_fn_ifs_split_value}" >&2
      fn_locals_release "$var_fn_ifs_split_value" || return "$?"
      return 125;
    }
    eval "fn_locals_release && ${var_fn_ifs_split_varname}=\$2" ||
    { printf '%s\n' "fn_ifs_split:$LINENO: eval with status $?" >&2; return 125; }
    return 0
  else :
  fi
  test "$#" -gt 0 || { printf '%s\n' "fn_ifs_split:$LINENO: no args" >&2; return 127; }
  test "$#" -gt 1 || { printf '%s\n' "fn_ifs_split:$LINENO: missing IFS" >&2; return 127; }
  test "$#" -eq 3 || { printf '%s\n' "fn_ifs_split:$LINENO: extra operand '$3'" >&2; return 127; }
  fn_check_varname "${1}" || { printf '%s\n' "fn_ifs_split:$LINENO: invalid variable name '${1}'" >&2; return 127; }
  test "x${2}" != x || { printf '%s\n' "fn_ifs_split:$LINENO: IFS is empty" >&2; return 127; }
  eval "${1}=" || { printf '%s\n' "fn_ifs_split:$LINENO: eval '${1}=' failed with status $?" >&2; return 125; }
  fn_locals_declare 'var_varname' 'var_ifs'
  var_varname=$1
  var_ifs=$IFS
  IFS=$2
  { shift && shift; } || {
    var_varname=$?
    printf '%s\n' "fn_ifs_split:$LINENO: builtin 'shift' failed" >&2
    fn_locals_release "${var_varname}" || return "$?"
    return 125
  }
  # shellcheck disable=SC2048
  set x $* || {
    var_varname=$?
    IFS=' '
    printf '%s\n' "fn_ifs_split:$LINENO: builtin failed: set x $*" >&2
    IFS=$var_ifs
    fn_locals_release "${var_varname}" || return "$?"
    return 125
  }
  IFS=$var_ifs
  shift || {
    var_varname=$?
    printf '%s\n' "fn_ifs_split:$LINENO: shift failed" >&2
    fn_locals_release "${var_varname}" || return "$?"
    return 125
  }
  test "$#" -gt 0 || eval "${var_varname}=\"''\"" || {
    var_varname=$?
    printf '%s\n' "fn_ifs_split:$LINENO: eval failed" >&2
    fn_locals_release "${var_varname}" || return "$?"
    return 125
  }
  var_ifs=
  fn_quote_assign "var_ifs" "$@" || {
    var_varname=$?
    printf '%s\n' "fn_ifs_split:$LINENO: fn_quote_assign failed" >&2
    fn_locals_release "${var_varname}" || return "$?"
    return 125
  }
  set x "${var_ifs}" || {
    var_varname=$?
    printf '%s\n' "fn_ifs_split:$LINENO: command failed: set x \"\${var_ifs}\"" >&2
    fn_locals_release "${var_varname}" || return "$?"
    return 125
  }
  eval "fn_locals_release && ${var_varname}=\$2"
}

# fn_current_dir <VARNAME> <LINENO>
# ----------------------
# Determine current directory absolute path and assign it to <VARNAME>
fn_current_dir ()
{
  test "$#" -gt 0 || fn_abort 127 "${var_lineno-$LINENO}" "fn_current_dir:$LINENO: missing operand"
  test "$#" -gt 1 || fn_abort 127 "${var_lineno-$LINENO}" "fn_current_dir:$LINENO: missing LINENO"
  test "$#" -eq 2 || fn_abort 127 "${var_lineno-$LINENO}" "fn_current_dir:$LINENO: extra operand '${3}'"
  fn_is_uint "${2}" || fn_abort 127 "${var_lineno-$LINENO}" "fn_current_dir:$LINENO: invalid LINENO '${1}'"
  fn_check_varname "${1}" || fn_abort 127 "${2}" "fn_current_dir:$LINENO: invalid variable name '${1}'"
  case $1 in
    var_pwd) fn_locals_declare 'var_ls_di' 'var_pwd_ls_di' ;;
    var_ls_di) fn_locals_declare 'var_pwd' 'var_pwd_ls_di' ;;
    var_pwd_ls_di) fn_locals_declare 'var_pwd' 'var_ls_di' ;;
    *) fn_locals_declare 'var_pwd' 'var_ls_di' 'var_pwd_ls_di' ;;
  esac
  { var_pwd=`pwd 2>&1` || fn_abort "$?" "${2}" "fn_current_dir:$LINENO: working directory cannot be determined
${var_pwd}"; }
  test -n "${var_pwd}" || fn_abort 125 "${2}" "fn_current_dir:$LINENO: command 'pwd' returned an empty string"
  var_ls_di=`ls -di . 2>&1`  ||
  fn_abort "$?" "${2}" "fn_current_dir:$LINENO: command failed 'ls -di .' failed
${var_ls_di}"
  var_pwd_ls_di=`cd "$var_pwd" 2>&1 && ls -di . 2>&1` ||
  fn_abort "$?" "${2}" "fn_current_dir:$LINENO: command failed 'cd \"$var_pwd\" && ls -di .'
${var_pwd_ls_di}"
  test "X$var_ls_di" = "X$var_pwd_ls_di" || fn_abort 125 "${2}" "fn_current_dir:$LINENO: 'pwd' and 'ls' reports conflicting directories
'${var_ls_di}' != '${var_pwd_ls_di}'"
  test "x${1}" = 'var_pwd' || eval "${1}=\${var_pwd}" || fn_abort 125 "${2}" "fn_current_dir:$LINENO: eval failed $?"
  fn_locals_release
} # fn_current_dir

# fn_absolute_path <VARNAME> <PATH> <LINENO>
# ----------------------
# assigns the length of the stack STACKNAME to DEST
fn_absolute_path ()
{
  test "$#" -gt 0 || fn_abort 127 "${var_lineno-$LINENO}" "fn_absolute_path:$LINENO: usage: fn_absolute_path <VARNAME> <PATH> <LINENO>"
  test "$#" -gt 1 || fn_abort 127 "${var_lineno-$LINENO}" "fn_absolute_path:$LINENO: missing path"
  test "$#" -gt 2 || fn_abort 127 "${var_lineno-$LINENO}" "fn_absolute_path:$LINENO: missing LINENO"
  test "$#" -eq 3 || fn_abort 127 "${var_lineno-$LINENO}" "fn_absolute_path:$LINENO: extra operand '${4}'"
  fn_is_uint "${3}" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_absolute_path:$LINENO: invalid LINENO '${3}'"
  test "x${1}" != x || fn_abort 127 "${3}" "fn_absolute_path:$LINENO: variable name is empty"
  test "x${2}" != x || fn_abort 127 "${3}" "fn_absolute_path:$LINENO: empty string is not a valid path"
  fn_check_varname "${1}" || fn_abort "$?" "${3}" "fn_absolute_path:$LINENO: invalid variable name '${1}'"
  test "x${2}" != / || { eval "${1}=/" && return 0; } || fn_abort "$?" "${3}" "fn_absolute_path:$LINENO: builtin failed
eval '${1}=/'"
  fn_locals_declare 'var_lineno' 'var_varname' 'var_dirname' 'var_abs_dir_stack' 'var_abs_dir_stack_begin' 'var_abs_dir_stack_end'
  var_varname=$1
  var_lineno=$3
  var_dirname=
  case $2 in
    [\\/$]* | ?:[\\/]* ) var_dirname=$2 ;;
    *)
      # Relative path, must use current directory absolute path
      fn_current_dir 'var_dirname' "${var_lineno}"
      case $var_dirname in
        */ ) var_dirname=${var_dirname}${2} ;;
        * ) var_dirname=${var_dirname}/${2} ;;
      esac
      ;;
  esac
  fn_ifs_split 'var_dirname' '/' "${var_dirname}" || fn_abort "$?" "${var_lineno}" "fn_absolute_path:$LINENO: fn_ifs_split failed"
  eval "set x ${var_dirname}" || fn_abort "$?" "${var_lineno}" "fn_absolute_path:$LINENO: builtin failed
eval \"set x ${var_dirname}\""
  shift || fn_abort "$?" "${var_lineno}" "fn_absolute_path:$LINENO: shift failed"
  test "$#" -gt 0 || fn_abort "$?" "${var_lineno}" "fn_absolute_path:$LINENO: invalid path: ${var_dirname}"
  var_dirname=
  while test "$#" -gt 0; do
    case $1 in
      .) : ;;
      ..)
        fn_stack_pop_back 'var_abs_dir_stack' || {
          while test "$#" -gt 0; do fn_append 'var_dirname' "/${1}" && shift || break; done
          fn_abort "$?" "${var_lineno}" "fn_absolute_path:$LINENO: invalid path '${var_dirname}'"
        }
        ;;
      *)
        test "x${1}" = x ||
        fn_stack_push 'var_abs_dir_stack' "$1" ||
        fn_abort "$?" "${var_lineno}" "fn_absolute_path:$LINENO: 'fn_stack_push' failed with status $?" ;;
    esac
    shift || fn_abort "$?" "${var_lineno}" "fn_absolute_path:$LINENO: 'shift' failed with status $?"
  done
  while fn_stack_pop_front 'var_abs_dir_stack'; do
    test "${var_abs_dir_stack}" != x ||
    fn_abort 125 "${var_lineno}" "fn_absolute_path:$LINENO: 'var_abs_dir_stack' is empty"
    case $var_dirname in
        */ ) : ;;
        * ) var_abs_dir_stack="/${var_abs_dir_stack}" ;;
    esac
    fn_append 'var_dirname' "${var_abs_dir_stack}" ||
    fn_abort "$?" "${var_lineno}" "fn_absolute_path:$LINENO: 'fn_append' failed with status $?"
  done
  test "${var_dirname}" != x || fn_abort 125 "${var_lineno}" "fn_absolute_path:$LINENO: 'var_dirname' is empty"
  set x "${var_dirname}" || fn_abort "$?" "${var_lineno}" "fn_absolute_path:$LINENO: builtin set failed"
  eval "fn_locals_release && ${var_varname}=\$2" ||
  fn_abort "$?" "${var_lineno}" "fn_absolute_path:$LINENO: eval failed
fn_locals_release && ${var_varname}=\$2"
} # fn_absolute_path

# fn_fmt_var <VARNAME> <FMT> [...ARGS]
# ----------------------------------------
# Logs to STDOUT only if `--quiet` is not set.
fn_fmt_var()
{
  test "$#" -gt 1 || fn_abort 127 "${var_lineno-$LINENO}" "fn_fmt_var:$LINENO: missing operand"
  test "x${1}" != 'x' || fn_abort 127 "${var_lineno-$LINENO}" "fn_fmt_var:$LINENO: variable name is empty"
  fn_check_varname "${1}" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_fmt_var:$LINENO: invalid variable name '${1}'"
  test "x${2}" != x ||
  { eval "${1}=" || fn_abort "$?" "${var_lineno-$LINENO}" "fn_fmt_var:$LINENO: eval failed 'eval ${1}='"; return 0; }
  eval "shift && fn_eval_assign '$1' 'fn_printf' \"\$@\""
} # fn_fmt_var

fn_fmt_filesize ()
{
  test "$#" -eq 2 || fn_abort 1 "${var_lineno-$LINENO}" "fn_fmt_filesize:$LINENO: expected 2 arguments, provided $#"
  test "$2" -ge 0 || fn_abort 1 "${var_lineno-$LINENO}" "fn_fmt_filesize:$LINENO: invalid filesize '$2'"
  if test "$2" -gt 1048576;
  then
    fn_arith "$1" '(' 1048575 '+' "$2" ')' '/' 1048576 || fn_abort 1 "${var_lineno-$LINENO}" "fn_fmt_filesize:$LINENO: fn_arith failed"
    eval "$1=\${${1}}MB" || fn_abort 1 "${var_lineno-$LINENO}" "fn_fmt_filesize:$LINENO: eval failed"
  else
    fn_arith "$1" '(' 1023 '+' "$2" ')' '/' 1024 || fn_abort 1 "${var_lineno-$LINENO}" "fn_fmt_filesize:$LINENO: fn_arith failed"
    eval "$1=\${${1}}KB" || fn_abort 1 "${var_lineno-$LINENO}" "fn_fmt_filesize:$LINENO: eval failed"
  fi
}

# fn_fmt_array <VARNAME> <FMT> [...ARGS]
# ----------------------------------------
# Logs to STDOUT only if `--quiet` is not set.
fn_fmt_array()
{
  # s/\${1}\\\\\\\$\${4}\${2}/\\\$/g
  # s/[\x01-\x08]/${1}${2}&${4}${2}/g
  fn_locals_declare 'var_res' 'var_fmt' 'var_script'
  var_script='
  :begin
  $bend
  N
  bbegin
  :end
  s/\([\\$`"]\)/\${1}\\\\\\\1\${4}\${2}/g
  s/\${1}\\\\\\\$\${4}\${2}/\\$/g
  s/\x09/\${1}\${2}\\\\t\${4}\${2}/g
  s/\x0a/\${1}\${2}\\\\n\${4}\${2}/g
  s/\x0d/\${1}\${2}\\\\r\${4}\${2}/g
  s/\x01/\${1}\${2}\\\\x01\${4}\${2}/g
  s/\x02/\${1}\${2}\\\\x02\${4}\${2}/g
  s/\x03/\${1}\${2}\\\\x03\${4}\${2}/g
  s/\x04/\${1}\${2}\\\\x04\${4}\${2}/g
  s/\x05/\${1}\${2}\\\\x05\${4}\${2}/g
  s/\x06/\${1}\${2}\\\\x06\${4}\${2}/g
  s/\x07/\${1}\${2}\\\\x07\${4}\${2}/g
  s/\x08/\${1}\${2}\\\\x08\${4}\${2}/g
  s/\x09/\${1}\${2}\\\\x09\${4}\${2}/g
  s/\x0a/\${1}\${2}\\\\x0A\${4}\${2}/g
  s/\x0b/\${1}\${2}\\\\x0B\${4}\${2}/g
  s/\x0c/\${1}\${2}\\\\x0C\${4}\${2}/g
  s/\x0d/\${1}\${2}\\\\x0D\${4}\${2}/g
  s/\x0e/\${1}\${2}\\\\x0E\${4}\${2}/g
  s/\x0f/\${1}\${2}\\\\x0F\${4}\${2}/g
  s/\x10/\${1}\${2}\\\\x10\${4}\${2}/g
  s/\x11/\${1}\${2}\\\\x11\${4}\${2}/g
  s/\x12/\${1}\${2}\\\\x12\${4}\${2}/g
  s/\x13/\${1}\${2}\\\\x13\${4}\${2}/g
  s/\x14/\${1}\${2}\\\\x14\${4}\${2}/g
  s/\x15/\${1}\${2}\\\\x15\${4}\${2}/g
  s/\x16/\${1}\${2}\\\\x16\${4}\${2}/g
  s/\x17/\${1}\${2}\\\\x17\${4}\${2}/g
  s/\x18/\${1}\${2}\\\\x18\${4}\${2}/g
  s/\x19/\${1}\${2}\\\\x19\${4}\${2}/g
  s/\x1a/\${1}\${2}\\\\x1A\${4}\${2}/g
  s/\x1b/\${1}\${2}\\\\x1B\${4}\${2}/g
  s/\x1c/\${1}\${2}\\\\x1C\${4}\${2}/g
  s/\x1d/\${1}\${2}\\\\x1D\${4}\${2}/g
  s/\x1e/\${1}\${2}\\\\x1E\${4}\${2}/g
  s/\x1f/\${1}\${2}\\\\x1F\${4}\${2}/g
  s/\x7f/\${1}${2}\\\\x7F${4}${2}/g
  s/^x/\${1}\${2}\\"\${4}\${2}/
  s/x$/\${4}\${1}\${2}\\"\${4}/'
  var_res='"['
  while test "$#" -gt 0; do
    var_fmt=`printf 'x%sx' "$1" | LC_ALL=C sed "$var_script"` || return "$?"
    fn_append 'var_res' "$var_fmt" || return "$?"
    shift || return "$?"
    test "$#" -gt 0 || break
    fn_append 'var_res' ', ' || return "$?"
  done
  fn_append 'var_res' ']"' || return "$?"

  var_fmt=`tput sgr0` || return "$?"
  set x "$var_fmt" && shift || return "$?"

  var_fmt=`tput setaf 8` || return "$?"
  set x "$var_fmt" "$@" && shift || return "$?"

  var_fmt=`tput setaf 2` || return "$?"
  set x "$var_fmt" "$@" && shift || return "$?"

  var_fmt=`tput bold` || return "$?"
  set x "$var_fmt" "$@" && shift || return "$?"

  eval "fn_locals_release && printf '%s\n' $var_res" || return "$?"
} # fn_fmt_array

# fn_exec <LINENO> <VARNAME> <COMMAND> [...ARGUMENTS]
# ----------------------
# TODO
fn_exec()
{
  test "$#" -gt 0 || fn_abort 127 "${var_lineno-$LINENO}" "fn_exec:$LINENO: no arguments"
  test "x${1}" != x || fn_abort 127 "${var_lineno-$LINENO}" "fn_exec:$LINENO: lineno is empty"
  fn_is_uint "${1}" || fn_abort 127 "${var_lineno-$LINENO}" "fn_exec:$LINENO: invalid LINENO '${1}'"
  test "$#" -gt 1 || fn_abort 127 "${1}" "fn_exec:$LINENO: missing command"
  test "x${2}" != x || fn_abort 127 "${1}" "fn_exec:$LINENO: command is empty"
  # shellcheck disable=SC2065
  test 0 -lt "${1}" > /dev/null 2>&1 || fn_abort "$?" "${1}" "fn_exec:$LINENO: invalid LINENO '${1}'"
  case $2 in
    */*)
      test -e "${2}" || fn_abort 1 "${1}" "fn_exec:$LINENO: command not found '${2}'"
      test -f "${2}" || fn_abort 1 "${1}" "fn_exec:$LINENO: not a executable file '${2}'"
      test -x "${2}" || fn_abort 1 "${1}" "fn_exec:$LINENO: the file is no executable '${2}'
try: chmod +x '${2}'"
      ;;
    cd|set|shift) : ;;
    *)
      command -v "${2}" > /dev/null 2>&1 || fn_abort "$?" "${1}" "fn_exec:$LINENO: neither executable or builtin '${2}'"
      ;;
  esac
  fn_locals_declare 'var_line' 'var_cmd' 'var_msg' 'var_status'
  var_line=$1
  var_msg=
  var_cmd=
  shift || fn_abort "$?" "${var_line}" "fn_exec:$LINENO: shift failed $?"
  fn_quote_assign 'var_cmd' "$@" || fn_abort "$?" "${var_line}" "fn_exec:$LINENO: fn_quote_assign failed $?"
  test "x${opt_verbose-no}" != 'xyes' || fn_fmt_array "$@" >&2

  # Execute command and escape it's output
  var_status=0; eval "${var_cmd}" || var_status=$?
  test 0 -le "${var_status}" > /dev/null 2>&1 || var_status=1

  if test "${var_status}" -gt 0
  then :
    var_msg=
    fn_fmt_var 'var_msg' '%s@n%s @n' "command '" "${1}" "' failed with status ${var_status}
COMMAND:" "${var_cmd}" || var_msg="COMMAND: ${var_cmd}"
    fn_abort "${var_status}" "${var_line}" "${var_msg}"
  else :
  fi
  fn_locals_release "${var_status}"
} # fn_exec

# fn_create_directory_recursive <PATH> <LINENO>
# ----------------------
# assigns the length of the stack STACKNAME to DEST
fn_create_directory_recursive ()
{
  # validate arguments
  test "$#" -gt 0 || fn_abort 127 "${var_lineno-$LINENO}" "fn_create_directory_recursive:$LINENO: no args"
  test "$#" -gt 1 || fn_abort 127 "${var_lineno-$LINENO}" "fn_create_directory_recursive:$LINENO: missing LINENO"
  test "$#" -eq 2 || fn_abort 127 "${var_lineno-$LINENO}" "fn_create_directory_recursive:$LINENO: extra operand '${3}'"
  fn_is_uint "${2}" || fn_abort 127 "${var_lineno-$LINENO}" "fn_create_directory_recursive:$LINENO: invalid lineno '${1}'"
  test "x${1}" != x || fn_abort 127 "${2}" "fn_create_directory_recursive:$LINENO: path is empty"
  test -d '/' || fn_abort 127 "${2}" "fn_create_directory_recursive:$LINENO: root directory doesn't exists"
  test "x${1}" != x/ || return 0

  # convert <PATH> to absolute
  fn_locals_declare 'var_lineno' 'var_dir'
  var_lineno=$2
  var_dir=
  fn_absolute_path 'var_dir' "${1}" "${var_lineno}"

  # split path components
  fn_ifs_split 'var_dir' '/' "${var_dir}" || fn_abort "$?" "${var_lineno}" "fn_create_directory_recursive:$LINENO: fn_ifs_split failed"
  test "x${var_dir}" != x || fn_abort "$?" "${var_lineno}" "fn_create_directory_recursive:$LINENO: invalid path '${2}'"
  eval "set x ${var_dir}" || fn_abort "$?" "${var_lineno}" "fn_create_directory_recursive:$LINENO: eval failed
set x ${var_dir}"
  shift || fn_abort "$?" "${var_lineno}" "fn_create_directory_recursive:$LINENO: shift failed"
  test "$#" -gt 0 || fn_abort 125 "${var_lineno}" "fn_create_directory_recursive:$LINENO: invalid path ${var_dir}"

  # Find the first component which doesn't exists
  var_dir=/
  while test "$#" -gt 0
  do
    test "x${1}" != x || { shift && continue; } || fn_abort "$?" "${1}" "fn_create_directory_recursive:$LINENO: shift failed"
    if test -e "${var_dir}${1}"
    then
      var_dir=${var_dir}${1}
      test -d "${var_dir}" || fn_abort 1 "${var_lineno}" "not a directory '${var_dir}'"
      test -x "${var_dir}" || fn_abort 1 "${var_lineno}" "no write permission to directory '${var_dir}'"
      var_dir=${var_dir}/
    else break
    fi
    shift || fn_abort "$?" "${var_lineno}" "fn_create_directory_recursive:$LINENO: shift failed"
  done

  case $# in
    0)
      # The provided path already exists
      fn_locals_release
      return 0
      ;;
    1)
      # Use 'mkdir -v <path>' if there's just one component
      fn_exec "${var_lineno}" "${cmd_mkdir-mkdir}" -v "${var_dir}${1}"
      fn_locals_release
      return 0
      ;;
    *) : ;;
  esac

  # Merge remaining components
  var_dir=${var_dir}${1}
  while test "$#" -gt 1
  do
    shift || fn_abort "$?" "${var_lineno}" "fn_create_directory_recursive:$LINENO: shift failed"
    var_dir=${var_dir}/${1}
  done

  # More than one component, use 'mkdir -pv <path>'
  fn_exec "${var_lineno}" "${cmd_mkdir-mkdir}" -pv "${var_dir}"
  { test -e "${var_dir}" && test -d "${var_dir}"; } ||
  fn_abort "$?" "${var_lineno}" "fn_create_directory_recursive:$LINENO: command '${cmd_mkdir-mkdir}' failed to create directory
'${var_dir}'"
  fn_locals_release
} # fn_create_directory_recursive

#################
# CONFIGURATION #
#################
# Enable verbose logs
opt_verbose=yes

# Rust nightly version used by `cargo fmt`
opt_rust_nightly_version=2025-06-27

# Exit script on error
set -e || fn_abort "$?" "$LINENO" "command 'set -e' failed with status $?"

# Consider read undefined variables an error
set -u || fn_abort "$?" "$LINENO" "command 'set -u' failed with status $?"

# Disable glob expansion, ex: ./*
set -f || fn_abort "$?" "$LINENO" "command 'set -f' failed with status $?"

######################
# CHECK DEPENDENCIES #
######################
test "${PATH+y}" || fn_abort "$?" "$LINENO" "variable 'PATH' is undefined"
test "${PATH_SEPARATOR+y}" || fn_abort "$?" "$LINENO" "variable 'PATH_SEPARATOR' is undefined"

# Check if the `sed` is installed
cmd_sed=
cmd_sed=`fn_path_lookup sed 2>&1` || fn_abort "$?" "$LINENO" "${cmd_sed}"

# Check if the `expr` is installed
cmd_expr=
cmd_expr=`fn_path_lookup expr 2>&1` || fn_abort "$?" "$LINENO" "${cmd_expr}"

# Check if the `cargo` is installed
cmd_cargo=
cmd_cargo=`fn_path_lookup cargo 2>&1` || fn_abort "$?" "$LINENO" "${cmd_cargo}
please visit 'https://www.rust-lang.org/tools/install"

# Check if the `rustup` is installed
cmd_rustup=
cmd_rustup=`fn_path_lookup rustup 2>&1` || fn_abort "$?" "$LINENO" "${cmd_rustup}
please visit 'https://www.rust-lang.org/tools/install"

# Check if the `dprint` is installed
cmd_dprint=
cmd_dprint=`fn_path_lookup dprint 2>&1` || fn_abort "$?" "$LINENO" "${cmd_dprint}
Please install it by running: '${cmd_cargo}' install --locked dprint"

# Check if the cargo-deny is installed
cmd_cargo_deny=
cmd_cargo_deny=`fn_path_lookup cargo-deny 2>&1` || fn_abort "$?" "$LINENO" "${cmd_cargo_deny}
Please install it by running: '${cmd_cargo}' install --locked cargo-deny"

# Check if the shellcheck is installed
cmd_shellcheck=
cmd_shellcheck=`fn_path_lookup shellcheck 2>&1` || fn_abort "$?" "$LINENO" "${cmd_shellcheck}
please visit https://github.com/koalaman/shellcheck?tab=readme-ov-file#installing"

#########################################
# FORMAT CODE AND CHECK VULNERABILITIES #
#########################################
# Convert relative path to absolute path
fn_absolute_path var_basedir "${var_basedir}/.." "$LINENO"

# Make sure we are in the project root directory
fn_cd "${var_basedir}" "$LINENO"
fn_is_file "${var_basedir}/Cargo.toml" "$LINENO"

# Format shell scripts
fn_exec "$LINENO" "${cmd_shellcheck}" \
  --enable=all \
  --severity=style \
  "${var_basedir}/scripts/check.sh"

# Format rust code
fn_exec "$LINENO" "${cmd_cargo}" "+nightly-${opt_rust_nightly_version}" fmt --all

# Format TOML, json markdown and dockerfiles
fn_exec "$LINENO" "${cmd_dprint}" fmt

# Check package vulnerabilities and licenses
fn_exec "$LINENO" "${cmd_cargo}" deny check

# run cargo clippy
fn_exec "$LINENO" "${cmd_cargo}" \
  clippy \
  --locked \
  --workspace \
  --examples \
  --tests \
  --all-features \
  -- \
  -Dwarnings \
  -Dclippy::unwrap_used \
  -Dclippy::expect_used \
  -Dclippy::nursery \
  -Dclippy::pedantic \
  -Aclippy::module_name_repetitions
