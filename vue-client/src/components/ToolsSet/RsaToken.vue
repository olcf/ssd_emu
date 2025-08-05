<template>
  <div
    class="flex items-center rounded-full shadow-lg p-4 relative"
  >
  <div class="rsa-circle rounded-full h-100px bg-gray-300 p-3">

    <!-- Left: RSA Logo -->
    <div
      class="bg-blue-900 text-white h-20 w-20 rounded-full flex items-center justify-center text-center font-bold text-xs p-4 reflective-rsa "
    >
      <div>
        <div class="text-lg bg-red-600 rounded-lg">RSA</div>
        <div class="text-[10px]">SecurID&reg;</div>
      </div>
    </div>
  </div>

    <div class="rsa-rectangle bg-gray-300 py-1.5 pr-3.5 flex -ml-4 pl-3.5 flex-col gap-1 items-end rounded-r-lg ">
      <!-- Right: Token Display -->
      <div class="flex relative">
        <div
          class="flex bg-gradient-to-b from-[#dce1e4] via-[#b7c1c8] to-[#8d9ba4] p-0.5 rounded-md"
        >
          <!-- Expiration Bar -->
          <div class="w-2 h-0.5 mx-1 mt-2  grid">
            <div
              v-for="i in 6"
              :key="i"
              :class="[
                'my-px  border rounded-sm',
                i <= 6 - progressBars ? 'border-gray-300' : 'border-gray-900',
              ]"
            ></div>
          </div>
        <!-- Token Code -->
          <div
            class="font-bold text-gray-800 animate-blink mt-0.5 tracking-tight pr-1"
            :style="{ fontFamily: 'E1234, monospace', fontSize: '1.6rem' }"
          >
            {{ token }}
          </div>
        </div>
      </div>
      <!-- Secured by RSA -->
      <div
        class=" text-[8px] bg-blue-900 text-white px-1 py-0.2 rounded-lg w-20"
      >
        Secured by <span class="bg-red-600 py-0.1 px-0.5 rounded-sm">RSA</span>
      </div>
    </div>

  </div>
</template>

<script setup>
import { useToolsetStore } from '@/stores/toolsetStore'
import { ref, onMounted, onBeforeUnmount } from 'vue'

const toolsetStore = useToolsetStore()

const token = ref('')
const progressBars = ref(6) // has all the bars at first

let interval

function generateToken() {
  const generatedToken = String(Math.floor(100000 + Math.random() * 900000)) // 6-digit token
  toolsetStore.setRsaToken(generatedToken)
  return generatedToken
}

function updateToken() {
  const now = new Date()
  const seconds = now.getSeconds()
  const elapsedInCycle = seconds % 30

  // Decrease progress bars from 6 to 0 over 30 seconds
  progressBars.value = 6 - Math.floor(elapsedInCycle / 5)

  if (elapsedInCycle === 0) {
    token.value = generateToken()
  }
}


onMounted(() => {
  token.value = generateToken()
  updateToken()
  interval = setInterval(updateToken, 1000)
})

onBeforeUnmount(() => {
  clearInterval(interval)
})
</script>



<style scoped>
@keyframes blink {
  0%,
  100% {
    opacity: 1;
  }
  50% {
    opacity: 0.6;
  }
}

.animate-blink {
  animation: blink 1s step-end infinite;
}

.reflective-rsa{
   background: linear-gradient(
    to bottom,
    #3E5AB2,
    #1C367E 40%,
    #0F1F4C 80%
  );
  position: relative;
  overflow: hidden;
  box-shadow: inset 0 1px 2px rgba(255, 255, 255, 0.2),
              inset 0 -1px 2px rgba(0, 0, 0, 0.2);
}

.reflective-rsa::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 50%;
  background: linear-gradient(
    to bottom,
    rgba(255, 255, 255, 0.3),
    rgba(255, 255, 255, 0.01)
  );
}

</style>
