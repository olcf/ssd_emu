import { useUserStore } from '@/stores/user'
import axios from 'axios'

export const getAllJobsForMachine = async machine_id => {
  // TODO: implement get all jobs for machine in backend and frontend
  const userStore = useUserStore()
  const user_id = userStore.user_id

  const allJobsByMachineRequest = await axios.get(
    `/jobs?machine_id=${machine_id}`,
    { user_id },
  )
  const allJobsByMachine = await allJobsByMachineRequest.data
  return allJobsByMachine
}

export const getAllJobs = async () => {
  const userStore = useUserStore()
  const user_id = userStore.user_id

  const allJobsRequest = await axios.get('/jobs', { user_id })
  const allJobs = await allJobsRequest.data

  return allJobs
}

export const create = async newJob => {
  const userStore = useUserStore()
  newJob.user_id = userStore.user_id

  const newJobRequest = await axios.post('/jobs', newJob)
  return newJobRequest
}
