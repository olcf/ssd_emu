<template>
  <div id="xterm-terminal" class="w-full h-screen" >
  </div>
</template>

<script setup>
import { onMounted } from 'vue';
import { Terminal } from '@xterm/xterm';
import { FitAddon } from '@xterm/addon-fit';
import 'xterm/css/xterm.css'
import axios from 'axios';
import { useUserStore } from '@/stores/user';
let currentUserIdentifier;

onMounted(()=>{
  const xtermTerminal = document.getElementById("xterm-terminal");

  const terminal = new Terminal();
  const fitAddon = new FitAddon();
  terminal.loadAddon(fitAddon);
  terminal.open(xtermTerminal)
  fitAddon.fit();

  const userStore = useUserStore();
  currentUserIdentifier =  JSON.stringify({
    id: userStore.user_id,
    username: userStore.username,
    channel:'XtermChannel'
  });

  const socket = new WebSocket(axios.defaults.baseURL + '/cable', 'ws')
  socket.onopen= ()=>{
    socket.send(JSON.stringify({
      command:'subscribe',
      identifier:currentUserIdentifier
    }))
  }

  socket.onmessage = (event)=>{
    const message = JSON.parse(event.data)
    if(message.type === 'ping' ||message.type === 'confirm_subscription') return
    const output = message.message
    if(output) terminal.write(output)
  }

  terminal.onData(data=>{
    socket.send(JSON.stringify({
      command:'message',
      identifier:currentUserIdentifier,
      data:JSON.stringify({input:data})
    }))
  })

})
</script>