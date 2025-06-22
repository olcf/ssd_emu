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

export const getChapterById = async id => {
  const userStore = useUserStore()
  const allChapters = await axios.get(`/chapters/${id}`, {
    headers: {
      user_id: userStore.getUserId,
    },
  })
  const chaptersResult = await allChapters.data
  return chaptersResult
}

export const getChapterWithQuizzes = async id => {
  const userStore = useUserStore()
  const chapterWithQuizzes = await axios.get(`/chapters/${id}`, {
    headers: {
      user_id: userStore.getUserId,
    },
  })
  const currentChapterWithQuizzes = await chapterWithQuizzes.data
  return currentChapterWithQuizzes
}

export const completeChapter = async id => {
  const userStore = useUserStore()
  const userId = userStore.getUserId
  
  const response = await axios.post(`/chapters/${id}/complete`, {
    user_id: userId
  }, {
    headers: {
      user_id: userId,
    },
  })
  return response.data
}
