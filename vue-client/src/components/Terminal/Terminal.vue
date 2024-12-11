<template>
  <div class="bg-black h-full flex flex-col p-1" @click="selectTerminal">
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
    <div class="user-prompt">
      <span>{{ username }} $:</span>
      <input
        ref="input"
        v-model="commandText"
        autocomplete="off"
        @keydown="onKeyDown"
      />
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

const selectTerminal = function () {
  commandInput.value.focus()
}
const onKeyDown = function (event) {
  if (event.key === 'Enter' && commandText.value) {
    // execute command
    commands.value.push({ command: commandText.value, response: 'response' })

    // we will reset previous command counter to length  and input value to empty string as next prompt will be new command.
    previousCommandCounter.value = commands.value.length
    commandText.value = ''
  } else if (event.key === 'ArrowUp') {
    if (previousCommandCounter.value > 0) {
      previousCommandCounter.value--
    }
    console.log('Previous command counter ' + previousCommandCounter.value)
    commandText.value = commands.value[previousCommandCounter.value].command
    console.log(previousCommandCounter.value)
  } else if (event.key === 'ArrowDown') {
    if (previousCommandCounter.value < commands.value.length - 1) {
      previousCommandCounter.value++
    }
    commandText.value = commands.value[previousCommandCounter.value].command
  }
}
</script>
