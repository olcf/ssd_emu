import { useUserStore } from '@/stores/user'
import axios from 'axios'

export const getAllChaptersByMissionId = async id => {
  const userStore = useUserStore()
  const allChapters = await axios.get('/chapters', {
    user_id: userStore.user_id,
    mission_id: id,
  })
  const chaptersResult = await allChapters.data
  return chaptersResult
}
