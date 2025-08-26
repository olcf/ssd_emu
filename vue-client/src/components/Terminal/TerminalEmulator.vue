<template>
  <div
    class="h-full flex flex-col p-1 font-mono overflow-y-scroll"
    style="background-color: #282a36"
    @click="selectTerminal"
  >
    <AsciiEmu v-if="commands.length < 1"></AsciiEmu>
    <div v-for="(command, index) of commands" :key="index + '-' + command">
      <div class="command-response grid">
        <span>
          <span class="username-prompt">
            {{
              `${userStore.username}@${command.machine}${command.path}`
            }}</span
          >
          <b class="pr-2">$</b>{{ command.command }}
        </span>
        <span v-html="command.response" class="response"> </span>
      </div>
    </div>
  <!-- If CLI is expecting passcode, show the password prompt, else show regular prompt -->
    <div v-if="CLIStore.isExpectingPasscode" class="user-prompt flex items-center">
      <span class="username-prompt">
        Enter Your Passcode::
        </span>
        <input ref="input" v-model="userPasscode" autocomplete="off" @keydown="onPasscodeEntered"  />
    </div>
    <div v-else class="user-prompt flex items-center">
      <span
        ><span class="username-prompt">
          {{
            `${userStore.username}@${CLIStore.getMachineName}${commands[commands.length - 1]?.path || ''}`
          }} </span
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
import { ref, useTemplateRef } from 'vue'
import { validCommands } from './commandController'
import { parseCommand } from './commandParser'
import { useUserStore } from '@/stores/user'
import { useCLIStore } from '@/stores/commandLine'
import { beautifyTextToHTML } from './beautifyTextToHTML'
import AsciiEmu from './AsciiEmu.vue'
import axios from 'axios'
import { useToolsetStore } from '@/stores/toolsetStore'
import { api } from '@/apis'

let commandText = ref('')
let userPasscode = ref('')
// commands will be an array of objects with format of {command:String, response: HTML String}
let commands = ref([])

const previousCommandCounter = ref(commands.value.length)
const commandInput = useTemplateRef('input')
const inputWidth = ref('0ch')
const userStore = useUserStore()
const CLIStore = useCLIStore()
const toolsetStore = useToolsetStore()
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
  remoteMachineSocket.onmessage = async event => {
    const machineResponse = await JSON.parse(event.data)
    if (machineResponse.type === 'ping') {
      return
    }

    if (machineResponse.message) {
      const machineMessage = machineResponse.message
      const machineOutputError = machineMessage.output || machineMessage.error

      const styledOutput = beautifyTextToHTML(machineOutputError)
      commands.value.push({
        command: machineMessage.command,
        response: styledOutput,
        machine: CLIStore.getMachineName,
        path: machineMessage.path,
      })
    }
  }
  remoteMachineSocket.onerror = event => {
    alert('Error while communicating with remote machine!!' + event)
  }
  remoteMachineSocket.onclose = event => {
    alert('Connection with remote machine closed!!!' + event)
  }
}

const selectTerminal = function () {
  commandInput.value.focus({preventScroll: true})
}
const resizeInput = function () {
  const inputLength = commandText.value.length
  inputWidth.value = `${inputLength}ch`
}
const onPasscodeEntered = async function(event) {
  if(event.key === 'Enter'){
    if(userPasscode.value == toolsetStore.getRsaToken){
      const CLIStore = useCLIStore()
      CLIStore.setExpectingPasscode(false)
      let listOfMachines = await api.Machine.getAllMachines()
      const loginHost = CLIStore.getLoginHost
      let askedHost = listOfMachines.findIndex(machine => machine.name == loginHost)
      CLIStore.selectMachine(listOfMachines[askedHost])
    }else{
      userPasscode.value = "";
      alert("Please check RSA token through RSA button and re-enter your password!")
    }
  }
}
const onKeyDown = async function (event) {
  if (event.key === 'Enter' && commandText.value) {
    // If user enters any command that is available as default commands
    try {
      executeGlobalCommand(commandText.value)
    } catch (error) {
      // check if user is logged in machine, if so, then connect to machine and run command and print result here
      if (CLIStore.hasValidMachine) {
        executeCommandOnRemote(commandText.value)
      } else {
        // execute command
        const commandResponse = await executeCommand(commandText.value)
        const styledHTML = beautifyTextToHTML(commandResponse)
        // if commands array is empty, set it as empty string other wise put last path
        const lastPath = commands.value.at(-2)?.path || ''
        commands.value.push({
          command: commandText.value,
          response: styledHTML,
          machine: 'emu',
          path: lastPath,
        })
      }
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
const executeGlobalCommand = function (command) {
  const parsedCommand = parseCommand(command)
  if (parsedCommand.name === 'clear') {
    let lastCommand = commands.value.pop()
    lastCommand.response = ''
    lastCommand.command = 'clear'
    commands.value = []
    commands.value.push(lastCommand)
    return ''
  } else if (parsedCommand.name === 'exit') {
    commands.value = []
    CLIStore.exitFromMachine()

    return ''
  } else {
    // if it reaches to the end, it means we don't have a matching command name so throw a error
    throw new Error('Unrecognized Command')
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

      // only if executed command is ssh, then initialize websocket
      if (parsedCommand.name === 'ssh') {
        commands.value = []

        let userPassword = "abc"
        CLIStore.setExpectingPasscode(true)

        if(userPassword == toolsetStore.getRsaToken){

        // identifies the current user with id and username (something unique about user)
        socketIdentifier = JSON.stringify({
          id: userStore.user_id,
          username: userStore.username,
          channel: 'MachineCliChannel',
          machine: CLIStore.getMachineName,
        })
        setupWebSocket()
        }

        return executedOutput
      }
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
  const pathWhileExecute = commands.value.at(-1)?.path
  const sendingMessage = {
    command: 'message',
    data: JSON.stringify({
      command: command,
      path: pathWhileExecute,
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
