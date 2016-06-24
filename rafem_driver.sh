#!/bin/sh

params_file=$1
results_file=$2
sim_id=$(echo $params_file | cut -d . -f 3) # params file is of form params.in.[0-9]+

TOPDIR=$(pwd)
MPIRUN=/opt/openmpi/bin/mpirun
N_PROCS=$PBS_NP
RUN_APPLICATION="/home/kara5380/anaconda/bin/python run_model.py $results_file"

# Stage the simulation in the workdir
workdir=xim.${sim_id}
mkdir ${workdir} && cd ${workdir}
cp ${TOPDIR}/${params_file} .
dprepro ${params_file} ${TOPDIR}/run_model.py run_model.py

host_num=$(( (sim_id - 1) % N_PROCS + 1))
sed -n "${host_num}p" $PBS_NODEFILE > machinefile

$MPIRUN -np 1 -machinefile ./machinefile $RUN_APPLICATION

cp $results_file ${TOPDIR}
cd ${TOPDIR}
