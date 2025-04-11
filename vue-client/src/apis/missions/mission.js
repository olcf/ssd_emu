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

// TODO: add error handling and also find a way to handle the user_id
export const getMissionWithChapters = async id => {
  const userStore = useUserStore()
  const missionWithChapters = await axios.get(`/mission_with_chapters/${id}`, {
    headers: {
      user_id: userStore.getUserId,
      lol: 'lol info',
    },
  })
  const currentMissionWithChapters = await missionWithChapters.data
  return currentMissionWithChapters
}
