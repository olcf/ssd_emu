<script setup lang="ts">
import MilkdownEditor from '@/components/Editor/MilkdownEditor.vue';
import { MilkdownProvider } from '@milkdown/vue';

</script>

<template>
<MilkdownProvider>
  <MilkdownEditor/>
</MilkdownProvider>
</template>

