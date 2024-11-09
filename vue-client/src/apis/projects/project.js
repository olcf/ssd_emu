import { useUserStore } from '@/stores/user'
import axios from 'axios'

export const getAllProjects = async () => {
  const userStore = useUserStore()
  const allProjects = await axios.get('/projects', {
    user_id: userStore.user_id,
  })
  const projectsResult = await allProjects.data
  return projectsResult
}
