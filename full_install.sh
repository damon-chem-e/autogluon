#!/usr/bin/env bash
set -euo pipefail

# Get the directory of the script
script_dir=$(dirname "$0")

# Change the current directory to the script's directory
cd "$script_dir"

EDITABLE="true"
UV_FLAGS=""

while test $# -gt 0
do
    case "$1" in
        --non-editable) EDITABLE="false";;
        *) echo "Error: Unused argument: $1" >&2
           exit 1;;
    esac
    shift
done

# Check if we're in a Jupyter/Colab environment
IN_NOTEBOOK=$(python -c "
try:
    import google.colab
    print('colab')
except ImportError:
    try:
        shell = get_ipython().__class__.__name__
        if shell == 'ZMQInteractiveShell':  # Jupyter notebook or qtconsole
            print('jupyter')
        else:
            print('no')
    except (NameError, ImportError):
        print('no')
")

# If in Colab or Jupyter, use --system flag with uv
if [ "$IN_NOTEBOOK" != "no" ]; then
    echo "Detected $IN_NOTEBOOK environment. Using --system flag with uv."
    UV_FLAGS="--system"
fi

# Comment out or remove the uv-related sections
# if ! python -m pip show uv &> /dev/null; then
#     echo "uv could not be found. Installing uv..."
#     python -m pip install uv
# fi

# Replace uv commands with regular pip commands
if [ "$EDITABLE" == "true" ]; then
  # install common first to avoid bugs with parallelization
  python -m pip install --no-deps -e common/[tests]

  # install the rest
  python -m pip install -e core/[all,tests] -e features/ -e tabular/[all,tests] -e multimodal/[tests] -e timeseries/[all,tests] -e eda/ -e autogluon/

else
  # install common first to avoid bugs with parallelization
  python -m pip install --no-deps common/[tests]

  # install the rest
  python -m pip install core/[all,tests] features/ tabular/[all,tests] multimodal/[tests] timeseries/[all,tests] eda/ autogluon/
fi
