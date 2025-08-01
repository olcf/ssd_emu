<template>
    <Milkdown />
</template>

<script setup lang="ts">
import { Milkdown, useEditor } from "@milkdown/vue";
import { Crepe } from "@milkdown/crepe";

const props = defineProps({
    content:String
})

useEditor((root) => {
  const crepe = new Crepe({
    root,
    defaultValue: props.content,
  });
  crepe.setReadonly(true)
  
  return crepe;
})
</script>