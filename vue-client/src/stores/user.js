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
  },
  actions: {
    async login() {
      try {
        // update with username and password later
        const loginApiRequest = await axios.get('/users')
        const singleUser = await loginApiRequest.data[0]
        this.username = singleUser.username
        this.user_id = singleUser.id

        console.log(singleUser)
      } catch (error) {
        alert(error)
        console.log(error)
      }
    },
  },
})
