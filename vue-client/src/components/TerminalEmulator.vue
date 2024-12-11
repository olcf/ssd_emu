<template>
  <div>
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
      <Terminal
        welcome-message="Welcome to Emu(Supercomputer Emulation Project)"
        style="height: 100%"
        prompt="username $"
      ></Terminal>
    </div>
  </div>
</template>
<script setup>
import { api } from '@/apis'
import Terminal from 'primevue/terminal'
import TerminalService from 'primevue/terminalservice'
import { ref } from 'vue'
const maximizedWindow = ref(false)

const maximizeMinimizeTerminal = function () {
  maximizedWindow.value = !maximizedWindow.value
}
TerminalService.on('command', async command => {
  let commandList = command.split(' ')
  switch (commandList[0]) {
    case 'info':
      TerminalService.emit(
        'response',
        'Emu is supercomputer emulation project developed for Oak Ridge National Laboratory Interns(ORNL) by Software Service Department. See https://github.com/olcf/ssd_emu for more information.',
      )
      break
    case 'ls':
      if (commandList[1] == 'machines') {
        const machines = await api.Machine.getAllMachines()
        const machineName = machines.map(machine => machine.name)

        TerminalService.emit('response', 'Available machines: ' + machineName)
      }
      break
  }
  // TODO: Implement default methods and more commands after asking SSD.
})
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
  z-index: 100;
}
.minimized-window {
  position: relative;
  height: 100vh;
}
.max-min-icon {
  position: absolute;
  right: 1rem;
  top: 1rem;
  cursor: pointer;
}
</style>
