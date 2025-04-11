<template>
  <div>
    <div class="text-center text-3xl">
      Mission: {{ mission.title || 'Unavailable Mission' }}
    </div>
    <div class="flex flex-col gap-4">
      <div class="text-xl">Mission Description</div>
      <div class="flex"></div>
    </div>
  </div>
</template>
<script>
import { defineComponent } from 'vue'
import { api } from '@/apis'
export default defineComponent({
  name: 'SingleMission',
  data() {
    return {
      mission: {},
    }
  },
})
</script>
