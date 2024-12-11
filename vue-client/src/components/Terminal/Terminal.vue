<template>
  <div
    class="bg-black h-full flex flex-col p-1 font-mono"
    @click="selectTerminal"
  >
    <span>Welcome to Emu Sim</span>
    <div v-for="(command, index) of commands" :key="index + '-' + command">
      <div class="command-response grid">
        <span>
          {{ username }} $:
          {{ command.command }}
        </span>
        <span v-html="command.response"> </span>
      </div>
    </div>
    <div class="user-prompt flex items-center">
      <span>{{ username }} $:</span>
      <input
        ref="input"
        v-model="commandText"
        autocomplete="off"
        @keydown="onKeyDown"
        :style="{
          width: inputWidth,
          caretColor: 'transparent',
        }"
        @input="resizeInput"
      />
      <span class="blinking-cursor"></span>
    </div>
  </div>
</template>
<script setup>
import { ref, useTemplateRef } from 'vue'

let commandText = ref('')
const username = 'username'
let commands = ref([
  { command: 'hello', response: '<b>Printed new info</b>' },
  { command: 'hi', response: 'hello' },
])

const previousCommandCounter = ref(commands.value.length)
const commandInput = useTemplateRef('input')
const inputWidth = ref('1ch')

const selectTerminal = function () {
  commandInput.value.focus()
}
const resizeInput = function () {
  const inputLength = commandText.value.length
  inputWidth.value = `${inputLength}ch`
}
const onKeyDown = function (event) {
  if (event.key === 'Enter' && commandText.value) {
    // execute command

    const commandResponse = executeCommand(commandText.value)
    commands.value.push({
      command: commandText.value,
      response: commandResponse,
    })

    // we will reset previous command counter to length  and input value to empty string as next prompt will be new command.
    previousCommandCounter.value = commands.value.length
    commandText.value = ''
    resizeInput()
  } else if (event.key === 'ArrowUp') {
    if (previousCommandCounter.value > 0) {
      previousCommandCounter.value--
    }
    commandText.value = commands.value[previousCommandCounter.value].command
    console.log(previousCommandCounter.value)
  } else if (event.key === 'ArrowDown') {
    if (previousCommandCounter.value < commands.value.length - 1) {
      previousCommandCounter.value++
    }
    commandText.value = commands.value[previousCommandCounter.value].command
  }
}

const executeCommand = function (command) {
  const validCommands = [
    {
      command: 'info',
      docs: 'Info command is used to show information about this software!',
      execute: () => {
        return 'This application is EMU(Supercomputer emulation program)!'
      },
    },
    {
      command: 'ls',
      docs: 'ls works similar to other `ls` command on other applications',
      execute: () => {
        throw new Error("Ls don't work with no params")
      },
    },
  ]

  try {
    const givenMainCommand = command.split(' ')[0]
    const toBeExecuted = validCommands.find(
      eachCommand => eachCommand.command == givenMainCommand,
    )
    let executedOutput = ''
    if (toBeExecuted) {
      executedOutput = toBeExecuted.execute()
    } else {
      // error message for command not recognized
      executedOutput = 'Command not found' + command
    }
    return executedOutput
  } catch (error) {
    // This is place where we know there was problem with syntax/
    return 'Error found within command! ' + error
  }
}
</script>
<style scoped>
input {
  /* remove all formatting for this input */
  /* caret property is for controlling the cursor of input */
  caret-color: rgba(0, 0, 0, 0);
  all: unset;
  transition: width 0ms ease;
}
.blinking-cursor {
  display: inline-block;
  height: 1rem;
  width: 0.5rem;
  align-items: end;
  background-color: white;
  opacity: 1;
  animation: blink 1s infinite step-end;
}
@keyframes blink {
  0% {
    opacity: 1;
  }
  50% {
    opacity: 0;
  }
  100% {
    opacity: 1;
  }
}
</style>
