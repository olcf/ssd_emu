<template>
  <Splitter style="height: 80vh;">
    <SplitterPanel class="flex flex-col p-2">
      <textarea
        v-model="source"
        class="flex-grow p-2 mt-2 border rounded resize-none font-mono text-sm"
        placeholder="Write your markdown here..."
      />
    </SplitterPanel>

    <SplitterPanel class="flex flex-col p-2 overflow-auto">
      <MarkdownViewer :content="source" class="flex-grow overflow-auto markdown-body mt-2" />
    </SplitterPanel>
  </Splitter>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import MarkdownViewer from './MarkdownViewer.vue' // Adjust path as needed

const source = ref('')
</script>

<style>
textarea {
  min-height: 100%;
  font-family: Consolas, Monaco, 'Andale Mono', 'Ubuntu Mono', monospace;
  font-size: 1rem;
  line-height: 1.5;
  border: 1px solid #ddd;
  border-radius: 6px;
  outline: none;
  resize: vertical;
}
</style>
