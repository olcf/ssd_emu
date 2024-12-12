import { defineStore } from 'pinia'

export const useCLIStore = defineStore('CLIStore', {
  state: () => {
    return {
      machine: {},
    }
  },
  getters: {
    getMachine(state) {
      return state.machine
    },
  },
  actions: {},
})
