<template>
  <div class="bg-gray-700 rounded-xl p-5">
    <div class="flex items-center justify-between mb-4">
      <h4 class="text-lg font-medium text-white">
        Question {{ questionNumber }}
      </h4>
      <div class="flex items-center gap-2">
        <i
          :class="[
            'text-lg',
            quiz.is_answered
              ? 'pi pi-check-circle text-green-400'
              : 'pi pi-circle text-gray-500',
          ]"
          :title="quiz.is_answered ? 'Answered' : 'Not Answered'"
        ></i>
      </div>
    </div>
    
    <p class="text-gray-300 mb-4">{{ quiz.question }}</p>
    
    <!-- Multiple Choice Options -->
    <div v-if="quiz.question_type === 'mcq'" class="space-y-3">
      <div
        v-for="(option, optionIndex) in quiz.options"
        :key="optionIndex"
        class="flex items-center gap-3 p-3 rounded-lg border cursor-pointer transition-colors"
        :class="getOptionClasses(optionIndex)"
        @click="selectAnswer(optionIndex)"
      >
        <RadioButton
          v-model="selectedAnswer"
          :value="optionIndex"
          :disabled="quiz.is_answered"
          :inputId="`quiz-${quiz.id}-option-${optionIndex}`"
        />
        <label 
          :for="`quiz-${quiz.id}-option-${optionIndex}`"
          class="text-gray-300 cursor-pointer flex-1"
          @click="selectAnswer(optionIndex)"
        >
          {{ option }}
        </label>
      </div>
    </div>
    
    <!-- Submit Answer Button -->
    <div v-if="!quiz.is_answered" class="mt-4">
      <Button
        label="Submit Answer"
        icon="pi pi-check"
        :disabled="selectedAnswer === undefined"
        @click="submitAnswer"
        class="w-full"
      />
    </div>
    
    <!-- Explanation -->
    <div v-if="quiz.is_answered" class="mt-4 p-4 bg-gray-600 rounded-lg">
      <div class="flex items-center gap-2 mb-2">
        <i class="pi pi-info-circle text-blue-400"></i>
        <span class="font-medium text-white">Explanation</span>
      </div>
      <p class="text-gray-300">{{ quiz.explanation }}</p>
    </div>
    
    <!-- Retry Message for Incorrect Answers -->
    <div v-if="showRetryMessage && !quiz.is_answered" class="mt-4 p-4 bg-red-900/20 border border-red-400 rounded-lg">
      <div class="flex items-center gap-2 mb-2">
        <i class="pi pi-exclamation-triangle text-red-400"></i>
        <span class="font-medium text-red-300">Incorrect Answer</span>
      </div>
      <p class="text-red-200">Try again! Select a different answer and submit.</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  quiz: {
    type: Object,
    required: true,
  },
  questionNumber: {
    type: Number,
    required: true,
  },
})

const emit = defineEmits(['answer-submitted', 'quiz-completed'])

const selectedAnswer = ref(undefined)
const showRetryMessage = ref(false)

const getOptionClasses = (optionIndex) => {
  const baseClasses = 'border-gray-600 hover:border-gray-500'
  
  if (props.quiz.is_answered) {
    if (optionIndex === props.quiz.correct_option_index) {
      return 'border-green-400 bg-green-900/20'
    } else if (selectedAnswer.value === optionIndex && optionIndex !== props.quiz.correct_option_index) {
      return 'border-red-400 bg-red-900/20'
    }
  } else if (selectedAnswer.value === optionIndex) {
    return 'border-blue-400 bg-blue-900/20'
  }
  
  return baseClasses
}

const selectAnswer = (optionIndex) => {
  if (!props.quiz.is_answered) {
    selectedAnswer.value = optionIndex
    // Clear retry message when a new answer is selected
    showRetryMessage.value = false
  }
}

const submitAnswer = () => {
  if (selectedAnswer.value === undefined) {
    return
  }
  
  const isCorrect = selectedAnswer.value === props.quiz.correct_option_index
  
  if (isCorrect) {
    // Only mark as answered if the answer is correct
    props.quiz.is_answered = true
    props.quiz.selected_answer = selectedAnswer.value
    showRetryMessage.value = false
    
    // Emit the answer submission
    emit('answer-submitted', {
      quizId: props.quiz.id,
      selectedAnswer: selectedAnswer.value,
      isCorrect: true,
    })
  } else {
    // For incorrect answers, show retry message
    showRetryMessage.value = true
    
    // Emit the answer submission
    emit('answer-submitted', {
      quizId: props.quiz.id,
      selectedAnswer: selectedAnswer.value,
      isCorrect: false,
    })
  }
}
</script> 