import { useUserStore } from '@/stores/user'
import axios from 'axios'

export const getAllJobsForMachine = async machine_id => {
  // TODO: implement get all jobs for machine in backend and frontend
}

export const getAllJobs = async () => {
  const userStore = useUserStore()
  const user_id = userStore.user_id

  const allJobsRequest = await axios.get('/jobs', { user_id })
  const allJobs = await allJobsRequest.data

  return allJobs
}
