#!/usr/bin/env bash
### SLURM HEADER
#SBATCH --job-name=regenerate_loupe
#SBATCH --output=logs/regenerate_loupe.log
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=bill.flynn@jax.org
#SBATCH --account=robson-lab

#SBATCH --qos=batch
#SBATCH --time=04:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=32000

#SBATCH --export=NONE
### SLURM HEADER

set -eo pipefail

localcores=${SLURM_TASKS_PER_NODE}
PROJECT_DIR="/projects/robson-lab/research/brain-stem_rtn/"

name=$1
if [ -z $name ]; then
    echo "MUST SPECIFY NAME" >2
    exit 1
fi
cd ${PROJECT_DIR}/analysis/neurons/loupe/${name}

module load singularity
img="library://jaxreg.jax.org/singlecell/cellranger:2.2.0"
singularity run $img reanalyze \
    --id="$name" \
    --matrix="${PROJECT_DIR}/data/processed/aggregation/raw_gene_bc_matrices_h5.h5" \
    --agg="${PROJECT_DIR}/data/processed/aggregation/aggregation_csv.csv" \
    --barcodes="loupe_barcodes.csv" \
    --localcores=${localcores} \
    --localmem="28"
