import { defineStore } from 'pinia'

export const useCLIStore = defineStore('CLIStore', {
  state: () => {
    return {
      machine: null,
      expectingPasscode: false,
      // Host user wants to login to
      loginHost:''
    }
  },
  getters: {
    getMachineName(state) {
      return state.machine?.name || 'emu'
    },
    hasValidMachine(state) {
      return Boolean(state.machine)
    },
    getMachine(state) {
      return state.machine
    },
    isExpectingPasscode(state){
      return state.expectingPasscode
    },
    getLoginHost(state){
      return state.loginHost
    }
  },
  actions: {
    selectMachine(machine) {
      this.machine = machine
    },
    exitFromMachine() {
      this.machine = null
    },
    setExpectingPasscode(expectingPasscode){
      this.expectingPasscode = expectingPasscode
    },
    setLoginHost(hostname){
      this.loginHost = hostname
    }
  },
})
