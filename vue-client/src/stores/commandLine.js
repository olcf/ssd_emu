import { defineStore } from 'pinia'

export const useCLIStore = defineStore('CLIStore', {
  state: () => {
    return {
      machine: null,
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
  },
  actions: {
    selectMachine(machine) {
      this.machine = machine
    },
    exitFromMachine() {
      this.machine = null
    },
  },
})
