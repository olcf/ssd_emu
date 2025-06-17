<template>
  <div class="bg-gray-800 rounded-2xl p-6 shadow-md">
    <div class="flex items-center gap-3 mb-6">
      <i class="pi pi-question-circle text-yellow-400 text-2xl"></i>
      <h3 class="text-xl font-semibold text-white">Chapter Quizzes</h3>
    </div>
    
    <div v-if="quizzes.length === 0" class="text-center py-8">
      <i class="pi pi-info-circle text-gray-400 text-4xl mb-4"></i>
      <p class="text-gray-400">No quizzes available for this chapter.</p>
    </div>
    
    <div v-else class="space-y-6">
      <QuizCard
        v-for="(quiz, index) in quizzes"
        :key="quiz.id"
        :quiz="quiz"
        :question-number="index + 1"
        @answer-submitted="handleAnswerSubmitted"
      />
    </div>
    
    <!-- Quiz Progress Summary -->
    <div v-if="quizzes.length > 0" class="mt-6 p-4 bg-gray-700 rounded-lg">
      <div class="flex items-center justify-between mb-2">
        <span class="text-sm font-medium text-gray-300">Quiz Progress</span>
        <span class="text-sm text-gray-400">{{ answeredCount }}/{{ quizzes.length }} completed</span>
      </div>
      <ProgressBar 
        :value="quizProgressPercentage" 
        :showValue="true"
        class="h-2"
      />
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import QuizCard from './QuizCard.vue'

const props = defineProps({
  quizzes: {
    type: Array,
    required: true,
    default: () => [],
  },
})

const emit = defineEmits(['quiz-completed', 'all-quizzes-completed'])

const answeredCount = computed(() => {
  return props.quizzes.filter(quiz => quiz.is_answered).length
})

const quizProgressPercentage = computed(() => {
  if (props.quizzes.length === 0) return 0
  return Math.round((answeredCount.value / props.quizzes.length) * 100)
})

const handleAnswerSubmitted = (answerData) => {
  // Find the quiz and update its state
  const quizIndex = props.quizzes.findIndex(q => q.id === answerData.quizId)
  if (quizIndex !== -1) {
    const quiz = props.quizzes[quizIndex]
    
    if (answerData.isCorrect) {
      // Only mark as answered if the answer is correct
      quiz.is_answered = true
      quiz.selected_answer = answerData.selectedAnswer
      
      // Emit quiz completion event
      emit('quiz-completed', {
        quizId: answerData.quizId,
        isCorrect: answerData.isCorrect,
      })
      
      // Check if all quizzes are completed
      const allAnswered = props.quizzes.every(q => q.is_answered)
      if (allAnswered) {
        emit('all-quizzes-completed')
      }
    } else {
      // For incorrect answers, just emit the event but don't mark as completed
      emit('quiz-completed', {
        quizId: answerData.quizId,
        isCorrect: answerData.isCorrect,
      })
    }
  }
}
</script> 