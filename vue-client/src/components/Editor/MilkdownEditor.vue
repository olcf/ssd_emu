<template>
  <Milkdown />
</template>

<script setup lang="ts">
import { Milkdown, useEditor } from "@milkdown/vue";
import { Crepe } from "@milkdown/crepe";

const markdown = `This is your content!`;

useEditor((root) => {
  const crepe = new Crepe({
    root,
    defaultValue: markdown,
  });

  return crepe;
})
</script>