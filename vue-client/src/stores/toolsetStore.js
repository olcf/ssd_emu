import { defineStore } from 'pinia'

export const useToolsetStore = defineStore('ToolsetStore',{
  state:()=>{
    return {
      rsa:''
    }
  },
  getters: {
    getRsaToken(state){
      return state.rsa;
    }
  },
  actions: {
    setRsaToken(token){
      this.rsa = token;
    }
  }
})
