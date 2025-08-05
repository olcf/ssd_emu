<template>
  <div
    ref="dragWrapper"
    class="fixed left-3 z-50 cursor-move"
    :style="{ top: posY + 'px' }"
    @mousedown="startDrag"
    @touchstart="startDrag"
  >
    <div
      class=" flex overflow-hidden bg-gray-900 rounded-full px-2 py-2 shadow-lg"
    >
      <Button label="RSA" @click="toggleComponent('rsa')" style="width: 50px; height: 50px; border-radius: 100%;"/>
    </div>

    <div class="flex flex-col space-y-4 mt-4">
      <component :is="currentComponent" />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, computed } from 'vue'
import RsaToken from './RsaToken.vue'


const activeComponent = ref(null)
const isVisible = ref(false)

// To add new component, add a button and element inside this object as, "name": ComponentName
const componentMap = {
  rsa: RsaToken,
}

const currentComponent = computed(() => {
  return activeComponent.value ? componentMap[activeComponent.value] : null
})

function toggleComponent(id) {
  if (activeComponent.value === id && isVisible.value) {
    // Collapse if already open
    isVisible.value = false
    activeComponent.value = null
  } else {
    // Show another component
    activeComponent.value = id
    isVisible.value = true
  }
}


const posY = ref(window.innerHeight - 150) // initial vertical position near bottom
const dragWrapper = ref(null)

let dragging = false
let startY = 0
let startPosY = 0

// Found this online on a repo
function onMouseMove(e) {
  if (!dragging) return
  // If we want to make it compatible for ipad or touch devices, this wont work
  const clientY =  e.clientY

  let newY = startPosY + (clientY - startY)

  const maxY = window.innerHeight - (dragWrapper.value?.offsetHeight || 100)
  newY = Math.min(Math.max(0, newY), maxY)

  posY.value = newY
}

function onMouseUp() {
  dragging = false
  window.removeEventListener('mousemove', onMouseMove)
  window.removeEventListener('touchmove', onMouseMove)
  window.removeEventListener('mouseup', onMouseUp)
  window.removeEventListener('touchend', onMouseUp)
}

function startDrag(e) {
  e.preventDefault()
  dragging = true
  startY = e.clientY
  startPosY = posY.value

  window.addEventListener('mousemove', onMouseMove)
  window.addEventListener('touchmove', onMouseMove, { passive: false })
  window.addEventListener('mouseup', onMouseUp)
  window.addEventListener('touchend', onMouseUp)
}

onMounted(() => {
  window.addEventListener('resize', () => {
    const maxY = window.innerHeight - (dragWrapper.value?.offsetHeight || 100)
    posY.value = Math.min(posY.value, maxY)
  })
})

onBeforeUnmount(() => {
  window.removeEventListener('mousemove', onMouseMove)
  window.removeEventListener('touchmove', onMouseMove)
  window.removeEventListener('mouseup', onMouseUp)
  window.removeEventListener('touchend', onMouseUp)
})
</script>
