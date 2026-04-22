<template>
  <div
    class="shrink-0 min-h-0 flex flex-col"
    :style="{ height: isCollapsed ? '2.5rem' : '40vh' }"
  >
    <div
      :class="[
        'flex flex-col h-full bg-[#1e1e1e]',
        maximizedWindow
          ? 'fixed top-0 left-0 h-screen w-screen z-[1000] rounded-none'
          : 'h-full',
      ]"
    >
      <div
        class="flex items-center justify-between px-2 min-h-[2.5rem] shrink-0 bg-[#2d2d2d] text-white/90"
        :class="{ 'cursor-pointer': isCollapsed }"
        @click="isCollapsed && (isCollapsed = false)"
      >
        <span class="flex items-center">
          <i class="pi pi-code mr-2" />
          Terminal
        </span>
        <div class="terminal-header-actions flex items-center" @click.stop>
          <Button
            v-if="!isCollapsed"
            class="relative"
            icon="pi pi-window-maximize"
            variant="text"
            severity="contrast"
            v-tooltip.bottom="'Maximize'"
            @click="maximizeMinimizeTerminal"
          />
          <Button
            :icon="isCollapsed ? 'pi pi-chevron-up' : 'pi pi-chevron-down'"
            variant="text"
            severity="contrast"
            v-tooltip.bottom="isCollapsed ? 'Expand terminal' : 'Collapse terminal'"
            @click="toggleCollapse"
          />
        </div>
      </div>
      <div
        v-show="!isCollapsed"
        class="flex-1 min-h-0 relative"
      >
        <XtermTerminal v-if="CLIStore.hasValidMachine" />
        <TerminalEmulator v-else />
      </div>
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
const isCollapsed = ref(true)

function toggleCollapse() {
  if (maximizedWindow.value) {
    // If the terminal is maximized, minimize it then collapse it
    maximizedWindow.value = false
    isCollapsed.value = true
  } else {
    isCollapsed.value = !isCollapsed.value
  }
}

function maximizeMinimizeTerminal() {
  maximizedWindow.value = !maximizedWindow.value
}
</script>

<style scoped>
/* Overriding icons in actions to override buttons background */
.terminal-header-actions :deep(.p-button) {
  background: transparent;
  border-color: transparent;
  color: rgba(255, 255, 255, 0.9);
}
.terminal-header-actions :deep(.p-button:hover) {
  background: rgba(255, 255, 255, 0.08);
  border-color: transparent;
  color: #fff;
}
</style>
