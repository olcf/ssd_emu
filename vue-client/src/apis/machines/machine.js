import axios from 'axios'
import { useUserStore } from '@/stores/user'

export const getAllMachines = async () => {
  const userStore = useUserStore()
  const allMachineRequest = await axios.get('/machines', {
    user_id: userStore.user_id,
  })
  const machinesResult = await allMachineRequest.data

  return machinesResult
}

export const getMachine = async id => {
  const userStore = useUserStore()
  const allMachineRequest = await axios.get('/machines', {
    user_id: userStore.user_id,
    id,
  })
  const machinesResult = await allMachineRequest.data

  return machinesResult
}

export const create = async machine => {
  // update this later to create machine
  const userStore = useUserStore()
  machine.user_id = userStore.user_id

  const newMachine = await axios.post('/machines', machine)
  return newMachine
}
