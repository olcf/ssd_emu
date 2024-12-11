<template>
  <div style="height: 100%; position: relative">
    <div
      :class="{
        'maximized-window': maximizedWindow,
        'minimized-window': !maximizedWindow,
      }"
    >
      <Button
        class="max-min-icon"
        icon="pi pi-window-maximize"
        variant="text"
        severity="contrast"
        @click="maximizeMinimizeTerminal"
      >
      </Button>
      <Terminal></Terminal>
    </div>
  </div>
</template>
<script setup>
import Terminal from './Terminal/Terminal.vue'
import { ref } from 'vue'
const maximizedWindow = ref(false)

const maximizeMinimizeTerminal = function () {
  maximizedWindow.value = !maximizedWindow.value
}
</script>
<style>
.terminal-window {
  font-family: 'Courier New', Courier, monospace;
}
.maximized-window {
  position: fixed;
  top: 0px;
  left: 0px;
  height: 100vh;
  width: 100vw;
  z-index: 2;
}
.minimized-window {
  height: 100vh;
}
.max-min-icon {
  position: absolute !important;
  right: 1rem;
  top: 1rem;
  z-index: 3;
}
</style>
