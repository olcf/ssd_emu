<template>
  <div>
    <!-- Chapter Header -->
    <div class="text-center text-3xl mb-6">
      {{ chapter.title || 'Unavailable Chapter' }}
    </div>

    <!-- Chapter Content -->
    <div class="flex flex-col gap-6">
      <!-- Chapter Description -->
      <div class="bg-gray-800 rounded-2xl p-6 shadow-md">
        <div class="flex items-center gap-3 mb-4">
          <i class="pi pi-book text-blue-400 text-2xl"></i>
          <h2 class="text-xl font-semibold text-white">Learn about {{ chapter.title }}</h2>
        </div>
          <MarkdownViewer :content="chapter.content"></MarkdownViewer>
        <p v-if="chapter.contributors" class="my-2 text-gray-300 leading-relaxed">
          <span>Contributors:</span> <span class="text-gray-400">{{ chapter.contributors }}</span>
          <br/>
          <span>Reading Time:</span> <span class="text-gray-400">{{ chapter.duration_minutes }} mins</span>
        </p>
      </div>

      <!-- Chapter Progress -->
      <div class="bg-gray-800 rounded-2xl p-6 shadow-md">
        <div class="flex items-center justify-between mb-4">
          <div class="flex items-center gap-3">
            <i class="pi pi-chart-line text-green-400 text-xl"></i>
            <h3 class="text-lg font-semibold text-white">Progress</h3>
          </div>
          <div class="flex items-center gap-2">
            <i
              :class="[
                'text-xl',
                chapter.is_completed
                  ? 'pi pi-check-circle text-green-400'
                  : 'pi pi-circle text-gray-500',
              ]"
              :title="chapter.is_completed ? 'Completed' : 'Incomplete'"
            ></i>
            <span class="text-sm text-gray-300">
              {{ chapter.is_completed ? 'Completed' : 'In Progress' }}
            </span>
          </div>
        </div>
        <ProgressBar
          :value="progressPercentage"
          :showValue="true"
          class="h-3"
        />
      </div>

      <!-- Quizzes Section -->
      <QuizList
        v-if="chapter.quizzes && chapter.quizzes.length > 0"
        :quizzes="chapter.quizzes"
        @quiz-completed="handleQuizCompleted"
        @all-quizzes-completed="handleAllQuizzesCompleted"
      />

      <!-- Navigation Buttons -->
      <div class="flex justify-between items-center">
        <Button
          label="Back to Mission"
          icon="pi pi-arrow-left"
          text
          @click="goBackToMission"
          class="text-gray-300"
        />

        <div class="flex gap-3">
          <Button
            v-if="hasPreviousChapter"
            label="Previous Chapter"
            icon="pi pi-chevron-left"
            outlined
            @click="goToPreviousChapter"
          />

          <Button
            v-if="hasNextChapter"
            label="Next Chapter"
            icon="pi pi-chevron-right"
            @click="goToNextChapter"
            :disabled="!chapter.is_completed"
          />

          <Button
            v-else-if="chapter.is_completed"
            label="Complete Mission"
            icon="pi pi-check-circle"
            severity="success"
            @click="completeMission"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { defineComponent } from 'vue'
import { api } from '@/apis'
import { QuizList } from '@/components/Quizzes'
import MarkdownViewer from '@/components/Markdown/MarkdownViewer.vue'

export default defineComponent({
  name: 'SingleChapter',
  components: {
    QuizList,
    MarkdownViewer,
  },
  data() {
    return {
      chapter: {},
      missionChapters: [],
      currentChapterIndex: 0,
    }
  },
  computed: {
    progressPercentage() {
      if (!this.chapter.quizzes || this.chapter.quizzes.length === 0) {
        return this.chapter.is_completed ? 100 : 0
      }

      const answeredQuizzes = this.chapter.quizzes.filter(quiz => quiz.is_answered).length
      return Math.round((answeredQuizzes / this.chapter.quizzes.length) * 100)
    },
    hasPreviousChapter() {
      return this.currentChapterIndex > 0
    },
    hasNextChapter() {
      return this.currentChapterIndex < this.missionChapters.length - 1
    },
  },
  created: async function () {
    await this.updateNecessaryData()
  },
  watch: {
    async '$route.params.chapterId'(to, from) {
      await this.updateNecessaryData()
    },
  },
  methods: {
    async updateNecessaryData() {
      try {
        // Get the current chapter with quizzes
        const currentChapter = await api.Chapter.getChapterWithQuizzes(
          this.$route.params.chapterId
        )
        this.chapter = currentChapter

        // Get all chapters for this mission to enable navigation
        const allChapters = await api.Chapter.getAllChaptersByMissionId(
          this.$route.params.missionId
        )
        this.missionChapters = allChapters

        // Find current chapter index
        this.currentChapterIndex = this.missionChapters.findIndex(
          chapter => chapter.id === parseInt(this.$route.params.chapterId)
        )
      } catch (error) {
        console.error('Error loading chapter data:', error)
        this.$toast?.add({
          severity: 'error',
          summary: 'Error',
          detail: 'Failed to load chapter data',
          life: 3000,
        })
      }
    },

    handleQuizCompleted(quizData) {
      // Show result toast
      this.$toast?.add({
        severity: quizData.isCorrect ? 'success' : 'warn',
        summary: quizData.isCorrect ? 'Correct!' : 'Incorrect',
        detail: quizData.isCorrect ? 'Great job!' : 'Try again with a different answer',
        life: 3000,
      })
    },

    async handleAllQuizzesCompleted() {
      try {
        // Call backend API to mark chapter as completed
        await api.Chapter.completeChapter(this.$route.params.chapterId)

        // Mark chapter as completed
        this.chapter.is_completed = true

        this.$toast?.add({
          severity: 'success',
          summary: 'Congratulations!',
          detail: 'Chapter completed successfully!',
          life: 3000,
        })

        // Check if mission is completed
        try {
          const missionCompletion = await api.Mission.checkMissionCompletion(this.$route.params.missionId)
          if (missionCompletion.success) {
            this.$toast?.add({
              severity: 'success',
              summary: 'Mission Complete!',
              detail: 'Congratulations! You have completed the entire mission!',
              life: 5000,
            })
          }
        } catch (missionError) {
          console.error('Error checking mission completion:', missionError)
        }
      } catch (error) {
        console.error('Error completing chapter:', error)
        this.$toast?.add({
          severity: 'error',
          summary: 'Error',
          detail: 'Failed to complete chapter. Please try again.',
          life: 3000,
        })
      }
    },

    goBackToMission() {
      this.$router.push(`/mission/${this.$route.params.missionId}`)
    },

    goToPreviousChapter() {
      if (this.hasPreviousChapter) {
        const previousChapter = this.missionChapters[this.currentChapterIndex - 1]
        this.$router.push(`/mission/${this.$route.params.missionId}/chapter/${previousChapter.id}`)
      }
    },

    goToNextChapter() {
      if (this.hasNextChapter) {
        const nextChapter = this.missionChapters[this.currentChapterIndex + 1]
        this.$router.push(`/mission/${this.$route.params.missionId}/chapter/${nextChapter.id}`)
      }
    },

    completeMission() {
      this.$router.push(`/mission/${this.$route.params.missionId}`)
    },
  },
})
</script>


