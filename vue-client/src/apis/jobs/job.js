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
  if (
    newJob.cores &&
    newJob.script &&
    newJob.project_id &&
    newJob.machine_id &&
    newJob.name
  ) {
    const userStore = useUserStore()
    newJob.user_id = userStore.user_id

    const newJobRequest = await axios.post('/jobs', newJob)
    const newJobFromServer = await newJobRequest.data
    return newJobFromServer
  } else {
    throw new Error('Please provide all necessary fields')
  }
}

export const getById = async jobId => {
  if (jobId) {
    const userStore = useUserStore()
    let user = {}
    user.user_id = userStore.user_id

    const singleJobRequest = await axios.get(`/jobs/${jobId}`, user)
    const singleJob = await singleJobRequest.data
    return singleJob
  } else {
    throw new Error('Please provide all necessary fields')
  }
}

export const run = async jobId => {
  if (jobId) {
    const userStore = useUserStore()
    let user = {}
    user.user_id = userStore.user_id

    const jobRunRequest = await axios.patch(`/jobs/run/${jobId}`, user)
    const jobRun = await jobRunRequest.data
    return jobRun
  } else {
    throw new Error('Please provide all necessary fields')
  }
}
