import { useUserStore } from '@/stores/user'
import axios from 'axios'

export const getAllMissions = async () => {
  const userStore = useUserStore()
  const allMissions = await axios.get('/missions', {
    user_id: userStore.user_id,
  })
  const missionsResult = await allMissions.data
  return missionsResult
}
