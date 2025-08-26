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
      <XtermTerminal v-if="CLIStore.hasValidMachine" />
      <TerminalEmulator v-else ></TerminalEmulator>
    </div>
  </div>
</template>
<script setup>
import TerminalEmulator from '@/components/Terminal/TerminalEmulator.vue'
import { useCLIStore } from '@/stores/commandLine'
import { ref } from 'vue'
import XtermTerminal from './XtermTerminal.vue'

const CLIStore = useCLIStore()
const maximizedWindow = ref(false)

const maximizeMinimizeTerminal = function () {
  maximizedWindow.value = !maximizedWindow.value
}
</script>
<style>
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
  top: 3px;
  z-index: 3;
}
</style>
