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
  const allMachineRequest = await axios.get('/machines/' + id, {
    user_id: userStore.user_id,
    id,
  })
  const machinesResult = await allMachineRequest.data

  return machinesResult
}

export const create = async machine => {
  if (
    machine.name &&
    machine.storage &&
    machine.cores &&
    machine.nodes &&
    machine.gpus
  ) {
    const userStore = useUserStore()
    machine.user_id = userStore.user_id

    const newMachine = await axios.post('/machines', machine)
    return newMachine
  } else {
    throw new Error('Please fill all details for creating machine')
  }
}
