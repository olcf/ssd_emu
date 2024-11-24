<template>
  <span v-if="output !== null"> The code ran successfully. </span>
  <span v-else> You code couldn't run successfully. </span>
  <VCodeBlock highlightjs :code="output || error" lang="bash"></VCodeBlock>
</template>

<script setup>
defineProps({ output: String, error: String })
</script>
