<template>
  <div class="markdown-body" v-html="renderedHtml" />
</template>

<script setup lang="ts">
import { computed } from 'vue'
import MarkdownIt from 'markdown-it'
import 'github-markdown-css/github-markdown.css'

const props = defineProps({
  content: String,
})

const md = new MarkdownIt({
  html: true,
  linkify: true,
  typographer: true,
})

const renderedHtml = computed(() => md.render(props.content || ''))
</script>

<style>
.markdown-body {
  padding: 1rem 2rem;
  border-radius: var(--border-radius, 6px);
}

.markdown-body code {
  color: #0366d6;
  padding: 0.2em 0.4em;
  border-radius: 4px;
  font-family: Consolas, Monaco, 'Andale Mono', 'Ubuntu Mono', monospace;
  font-size: 0.9em;
}

.markdown-body pre {
  padding: 1em;
  border-radius: 6px;
  overflow-x: auto;
}

.markdown-body pre code {
  background-color: transparent;
  padding: 0;
  font-size: 1em;
  color: inherit;
  font-family: Consolas, Monaco, 'Andale Mono', 'Ubuntu Mono', monospace;
}
</style>
