import { useUserStore } from '@/stores/user'
import axios from 'axios'

export const getAllMissions = async () => {
  const allMissions = await axios.get('/missions')
  const missionsResult = await allMissions.data
  return missionsResult
}

// TODO: add error handling and also find a way to handle the user_id
export const getMissionWithChapters = async id => {
  const userStore = useUserStore()
  const missionWithChapters = await axios.get(`/mission_with_chapters/${id}`, {
    headers: {
      user_id: userStore.getUserId,
    },
  })
  const currentMissionWithChapters = await missionWithChapters.data
  return currentMissionWithChapters
}

export const checkMissionCompletion = async id => {
  const userStore = useUserStore()
  const response = await axios.post(`/missions/${id}/check_completion`, {}, {
    headers: {
      user_id: userStore.getUserId,
    },
  })
  return response.data
}
