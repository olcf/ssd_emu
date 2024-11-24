<template>
  <VCodeBlock highlightjs :code="combinedScript" lang="bash"></VCodeBlock>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  job: {
    required: true,
  },
})

const formattedTime = function () {
  const givenTime = props.job.walltime
  if (!givenTime) {
    return '00:00:00'
  } else {
    const hour = Math.floor(givenTime / 3600)
    const minutes = Math.floor((givenTime - hour * 3600) / 60)
    const seconds = Math.floor(givenTime - hour * 3600 - minutes * 60)

    return (
      hour.toString().padStart(2, '0') +
      ':' +
      minutes.toString().padStart(2, '0') +
      ':' +
      seconds.toString().padStart(2, '0')
    )
  }
}

let combinedScript = computed(() => {
  let topScriptPart = '#!/bin/bash\n\n'
  if (props.job.name) {
    topScriptPart += `#SBATCH -J ${props.job.name} \n`
  }
  if (props.job.project_name) {
    topScriptPart += `#SBATCH -A ${props.job.project_name} \n`
  }
  if (props.job.nodes) {
    topScriptPart += `#SBATCH -N ${props.job.nodes} \n`
  }
  if (props.job.cores) {
    topScriptPart += `#SBATCH --threads-per-core=${props.job.cores} \n`
  }
  if (props.job.slurm_cores) {
    topScriptPart += `#SBATCH -S ${props.job.slurm_cores} \n`
  }
  if (props.job.walltime) {
    topScriptPart += `#SBATCH -t ${formattedTime(props.job.walltime)} \n`
  }
  if (props.job.mail_user) {
    topScriptPart += `#SBATCH --mail-user=${props.job.mail_user} \n`
  }
  if (props.job.mail_type) {
    topScriptPart += `#SBATCH --mail-type=${props.job.mail_type} \n`
  }

  if (props.job.out_file) {
    topScriptPart += `#SBATCH -o ${props.job.out_file} \n`
  }
  if (props.job.err_file) {
    topScriptPart += `#SBATCH -e ${props.job.err_file} \n`
  }

  return topScriptPart + props.job.script
})
</script>
