Run a DAKOTA Parameter Study in Parallel
========================================

Run this example with,

    $ qsub pbs_submission

The Files
---------

`pbs_submission`: The submission script for PBS. This requests resources on
the cluster (the comment lines starting with `#PBS`), sets the environment,
and runs dakota in the work directory.

`dakota.in`: The dakota input file. This is set up to run a parameter
study of the heat model. The input parameters are the diffusivity
constance (`alpha`) and the grid spacing (`dx`). The responses are the
maximum and mean temperature of the surface at the end of the run.

`heat_driver.sh`: Stage simulations for each parameter combination and
run the model.

`heat.py`: The model. This will be called with two arguments. The first is
the input file and the second the output file. This script is written so
that the output file is a dakota response file.

`heat.yaml.template`: A template input file for the model. Values in curly
braces are substituted with values from dakota parameter files. The
substitution is done in `heat_driver.sh` with the `dprepro` command.
