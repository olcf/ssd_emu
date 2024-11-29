<template>
  <Terminal
    welcome-message="Welcome to Emu(Supercomputer Emulation Project)"
    prompt="username $"
    style="font-family: 'Courier New', Courier, monospace; height: 100%"
  ></Terminal>
</template>
<script setup>
import Terminal from 'primevue/terminal'
import TerminalService from 'primevue/terminalservice'

TerminalService.on('command', command => {
  if (command === 'info') {
    TerminalService.emit(
      'response',
      'Emu is supercomputer emulation project developed for Oak Ridge National Laboratory Interns(ORNL) by Software Service Department. See https://github.com/olcf/ssd_emu for more information.',
    )
  } else {
    TerminalService.emit(
      'response',
      'This command is not available. Commands available: info',
    )
  }
})
</script>
