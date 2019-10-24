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
study of the coupled rafem-cem model. The input parameters are the wave
climate diffusivity (`U`) and the wave height (`H`). The response is
sea level at the end of the run.

`rafem_driver.sh`: Stage simulations for each parameter combination and
run the model.

`run-model.py`: Python script for running the coupled rafem-cem model.
This will be called with two arguments. This will be called with the two
arguments specified in the dakota input file. This script is written so
that the output file is a dakota response file.