
if [[ ! $EXTRA_ENV == *" PACO"* ]]; then
  dir=$(dirname $BASH_SOURCE[@])
  dir=$(realpath $dir)
  #echo $dir
  if [ ! `echo "$PATH" | grep "$dir/riscv-tools/bin"` ]; then
    PATH=$dir/riscv-tools/bin:$PATH
  fi
  export RISCV=$dir/riscv-tools

  export PYTHONPATH=$PYTHONPATH:$dir/riscv-tools/py

  # this keeps track of environment modifications sourced into the shell.
  # basically a space separated list of environments.
  export EXTRA_ENV="$EXTRA_ENV"" PACO"
  # re-builds the PS1 environment variable to display EXTRA_ENV.
  refresh_prompt >/dev/null 2>/dev/null
fi
