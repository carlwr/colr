# `colr`
_colorize text on stdin, or run a util and colorize its output_
```help
NAME

  colr - colorize text on stdin, or run a util and colorize its
  output


SYNOPSIS

  cmd | colr

  colr util [util-opt]...

  colr util [util-opt]... [--colorDef|-_c] [RE grepOpt ansicolor]...


DESCRIPTION

  If no `util` is provided, text on stdin is colorized.

  If no `--colorDef` argument + following formatting rules triples
  is provided, some default formatting rules are applied.


OPTIONS

  -_c, --colorDef


ENVIRONMENT

  COLR_COLLECT
    If non-null, then with the `util` form, stderr is immediately
    merged with its stdout, after which the merged output will
    undergo the colorization process. The colorized output is then
    written to colr-s stdout. This is intended to avoid stdout/stderr
    out-of-order problems.

  COLR_NAMEIFY
    If non-null, then all single-quoted substrings of the processed
    text additionally undergoes named directory substitution.


EXAMPLES

  Will use default formatting rules, will produce identical output:

    colr print -l message error warning

    print -l message error warning | colr

    { echo message
      echo error echo warning >&2
    } | colr

  Will colorize kernel version in blue and any HH:MM:SS times in
  green:

    colr uname -a --colorDef \
      'kernel version [\d\.]+'  -i  '38;5;117' \ ' (\d\d|:)+ '
      ''  '38;5;119'

  Will print "a dir: '~/subdir'":

    print "a dir: '$HOME/subdir'" \ | COLR_NAMEIFY=1 colr

  Illustrating COLR_COLLECT:

    { COLR_COLLECT='' \
      colr zsh -c 'echo warning-text >&2' \

      COLR_COLLECT='1' \ colr zsh -c 'echo warning-text >&2'

    } | sed -E 's/$/  **on stdout**/'

    # output ("warning" colored on both lines): #   warning-text #
    warning-text  **on stdout**

```

