import axios from 'axios'
import { defineStore } from 'pinia'

export const useUserStore = defineStore('user', {
  state: () => {
    return {
      username: '',
      user_id: '',
    }
  },
  getters: {
    getUsername(state) {
      return state.username
    },
    getUserId(state) {
      return state.user_id
    },
    getUserRole(state) {
      return state.role
    }
  },
  actions: {
    async login() {
      try {
        // update with username and password later
        const loginApiRequest = await axios.get('/users')
        const singleUser = await loginApiRequest.data[0]
        this.username = singleUser.username
        this.user_id = singleUser.id
        this.role = singleUser.role
      } catch (error) {
        alert(error)
      }
    },
  },
})
