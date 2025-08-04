<template>
  <Splitter>
    <SplitterPanel class="flex flex-col">
      <span class="text-center p-1">Markdown Source</span>
      <Milkdown/>
    </SplitterPanel>
    <SplitterPanel class="flex flex-col">
      <span class="text-center p-1">Markdown Output</span>
      <Textarea v-model="markdown" class="flex-1 resize-none" ></Textarea>
    </SplitterPanel>
  </Splitter>
  <Button @click="extractMarkdown"> Extract Markdown</Button>
</template>

<script setup lang="ts">
import { Milkdown, useEditor } from "@milkdown/vue";
import { Crepe } from "@milkdown/crepe";
import { ref } from "vue";

let markdown = ref('');
const crepe = ref(null)

useEditor((root) => {
  const c = new Crepe({
    root,
    defaultValue: 'Default Content',
  });
  crepe.value = c

  return c;
})



async function extractMarkdown(){
  markdown.value = await crepe.value.getMarkdown();
}


</script>
