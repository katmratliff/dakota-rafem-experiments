#!/bin/sh

export PATH=/home/kara5380/py-csdms/conda/bin:$PATH

params_file=$1
results_file=$2
sim_id=$(echo $params_file | cut -d . -f 3) # params file is of form params.in.[0-9]+

TOPDIR=$(pwd)

output_dir=/scratch/kara5380/${PBS_JOBID}

CP=/home/csdms/tools/pbstools/0.1/bin/pbsdcp 
MPIRUN=/opt/openmpi/bin/mpirun
N_PROCS=$PBS_NP

# Stage the simulation in the workdir
workdir=${TMPDIR}/xim.${sim_id}

mkdir ${workdir}.stage && cd ${workdir}.stage
cp ${TOPDIR}/${params_file} ${workdir}.stage
dprepro ${params_file} ${TOPDIR}/run_model.py ${workdir}.stage/run_model.py

host_num=$(( (sim_id - 1) % N_PROCS + 1))
sed -n "${host_num}p" $PBS_NODEFILE > machinefile

${CP} -r ${workdir}.stage ${workdir} && rm -rf ${workdir}.stage

RUN_APPLICATION="/home/kara5380/py-csdms/conda/bin/python ${workdir}/run_model.py ${workdir}/$results_file"

cd ${workdir} && $MPIRUN -np 1 -machinefile ${workdir}/machinefile $RUN_APPLICATION

node=$(cat ${workdir}/machinefile)
mkdir -p $output_dir

# copy model output to output directory
scp -r $node:${workdir} $output_dir

# copy results file back for dakota
scp $node:${workdir}/$results_file ${TMPDIR}

cd ${TOPDIR}

