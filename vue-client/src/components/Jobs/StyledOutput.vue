<template>
  <p class="p-1">
    <span v-if="job.out !== null">
      The code ran successfully. Your output was
      <i class="keyword">{{
        job.out_file ? ' saved in ' + job.out_file : ' displayed in STDOUT'
      }}</i>
    </span>
    <span v-else-if="job.err !== null">
      You code couldn't run successfully. Your output was
      <i class="keyword">{{
        job.err_file ? ' saved in ' + job.err_file : ' displayed in STDERR'
      }}</i>
    </span>
    <span v-else
      >Your Job is currently in <i class="keyword">{{ job.state }} </i> state
      with reason code of <i class="keyword">{{ job.job_reason_code }}</i> (Look
      into docs for more information)</span
    >
  </p>
  <Splitter>
    <SplitterPanel class="flex flex-col">
      <span class="text-center p-1">Script</span>
      <StyledScript :job="job"></StyledScript>
    </SplitterPanel>
    <SplitterPanel class="flex flex-col">
      <span class="text-center p-1">
        {{ job.out ? 'Output' : 'Error' }}
      </span>

      <VCodeBlock
        highlightjs
        v-if="job.out"
        :code="job.out"
        lang="bash"
      ></VCodeBlock>
      <span v-else-if="job.err" class="p-2 text-red-500">{{ job.err }}</span>
      <span v-else class="text-center">
        Please run your code to see the output
      </span>
    </SplitterPanel>
  </Splitter>
  <span class="p-1">
    Last updated/run at: {{ new Date(job.updated_at).toLocaleString() }}
  </span>
</template>

<script setup>
import StyledScript from './StyledScript.vue'

defineProps({ output: String, error: String, job: Object })
</script>
