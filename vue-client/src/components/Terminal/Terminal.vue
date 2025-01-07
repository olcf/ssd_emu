<template>
  <div
    class="h-full flex flex-col p-1 font-mono overflow-y-scroll"
    style="background-color: #282a36"
    @click="selectTerminal"
  >
    <AsciiEmu></AsciiEmu>
    <div v-for="(command, index) of commands" :key="index + '-' + command">
      <div class="command-response grid">
        <span>
          <span class="username-prompt">
            {{ userStore.username + '@emu' }}</span
          >
          <b class="pr-2">$</b>{{ command.command }}
        </span>
        <span v-html="command.response" class="response"> </span>
      </div>
    </div>
    <div class="user-prompt flex items-center">
      <span
        ><span class="username-prompt">
          {{ userStore.username + '@' + CLIStore.getMachineName }}</span
        ><b class="pr-2">$ </b>
      </span>
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
import { onMounted, ref, useTemplateRef } from 'vue'
import { validCommands } from './commandController'
import { parseCommand } from './commandParser'
import { useUserStore } from '@/stores/user'
import { useCLIStore } from '@/stores/commandLine'
import { beautifyTextToHTML } from './beautifyTextToHTML'
import AsciiEmu from './AsciiEmu.vue'
import axios from 'axios'

let commandText = ref('')
// commands will be an array of objects with format of {command:String, response: HTML String}
let commands = ref([])

const previousCommandCounter = ref(commands.value.length)
const commandInput = useTemplateRef('input')
const inputWidth = ref('0ch')
const userStore = useUserStore()
const CLIStore = useCLIStore()
let socketIdentifier
let remoteMachineSocket

// Websocket for connecting with remote machine!
const setupWebSocket = function () {
  remoteMachineSocket = new WebSocket(axios.defaults.baseURL + '/cable', 'ws')
  remoteMachineSocket.onopen = () => {
    const socketInitializerRequest = {
      command: 'subscribe',
      identifier: socketIdentifier,
    }
    remoteMachineSocket.send(JSON.stringify(socketInitializerRequest))
  }
  remoteMachineSocket.onmessage = event => {
    const machineResponse = JSON.parse(event.data)
    if (machineResponse.type === 'ping') {
      return
    }
    console.log('Response from machine ', machineResponse)
  }
  remoteMachineSocket.onerror = event => {
    alert('Error while communicating with remote machine!!' + event)
  }
  remoteMachineSocket.onclose = event => {
    alert('Connection with remote machine closed!!!' + event)
  }
}
onMounted(() => {
  // identifies the current user with id and username (something unique about user)
  socketIdentifier = JSON.stringify({
    id: userStore.user_id,
    username: userStore.username,
    channel: 'MachineCliChannel',
  })
  setupWebSocket()
})

const selectTerminal = function () {
  commandInput.value.focus()
}
const resizeInput = function () {
  const inputLength = commandText.value.length
  inputWidth.value = `${inputLength}ch`
}

const onKeyDown = async function (event) {
  if (event.key === 'Enter' && commandText.value) {
    // check if user is logged in machine, if so, then connect to machine and run command and print result here
    if (CLIStore.hasValidMachine) {
      executeCommandOnRemote(commandText.value)
    } else {
      // execute command
      const commandResponse = await executeCommand(commandText.value)
      const styledHTML = beautifyTextToHTML(commandResponse)
      commands.value.push({
        command: commandText.value,
        response: styledHTML,
      })
    }

    // we will reset previous command counter to length  and input value to empty string as next prompt will be new command.
    previousCommandCounter.value = commands.value.length
    commandText.value = ''
    resizeInput()
  } else if (event.key === 'ArrowUp') {
    if (previousCommandCounter.value > 0) {
      previousCommandCounter.value--
    }
    // update cursor and current command
    commandText.value = commands.value[previousCommandCounter.value].command
    resizeInput()
  } else if (event.key === 'ArrowDown') {
    if (previousCommandCounter.value < commands.value.length - 1) {
      previousCommandCounter.value++
    }

    // update cursor and current command
    commandText.value = commands.value[previousCommandCounter.value].command
    resizeInput()
  }
}

const executeCommand = async function (command) {
  try {
    const parsedCommand = parseCommand(command)
    if (parsedCommand.name === 'clear') {
      commands.value = []
      return ''
    }
    const toBeExecuted = validCommands.find(
      eachCommand => eachCommand.name == parsedCommand.name,
    )
    let executedOutput = ''
    if (toBeExecuted) {
      executedOutput = await toBeExecuted.execute(parsedCommand)
    } else {
      // error message for command not recognized
      executedOutput = 'Command not found ' + command
    }
    return executedOutput
  } catch (error) {
    // This is place where we know there was problem with syntax/
    return 'Error occurred while executing the command!<br/> ' + error
  }
}

// TODO: make it work so that backend won't report received unrecognized message
const executeCommandOnRemote = async function (command) {
  const sendingMessage = {
    command: 'message',
    data: JSON.stringify({
      cmd: command,
      machine: useCLIStore.getMachineName,
    }),
    identifier: socketIdentifier,
  }
  remoteMachineSocket.send(JSON.stringify(sendingMessage))
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
.username-prompt {
  color: #189261;
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
/* styles for cmd components */
.response key {
  color: red;
}
</style>
