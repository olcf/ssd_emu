<template>
  <Terminal
    welcome-message="Welcome to Emu(Supercomputer Emulation Project)"
    prompt="username $"
    style="font-family: 'Courier New', Courier, monospace; height: 100%"
  ></Terminal>
</template>
<script setup>
import { api } from '@/apis'
import Terminal from 'primevue/terminal'
import TerminalService from 'primevue/terminalservice'

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
