<script setup>
import { onMounted } from 'vue'
import { RouterView } from 'vue-router'
import LeftNavigationMenu from './components/LeftNavigation/LeftNavigationMenu.vue'
import { useUserStore } from './stores/user'
import TerminalEmulator from './components/Terminal/TerminalEmulator.vue'
const userStore = useUserStore()

onMounted(async () => {
  await userStore.login()
})
</script>

<template>
  <!-- Creating single Confirm Dialog so that it won't repeat for each call -->
  <ConfirmDialog></ConfirmDialog>
  <Toast></Toast>

  <!-- Here we can create header -->
  <Splitter layout="vertical" class="h-screen">
    <SplitterPanel :size="96" :min-size="30">
      <Splitter :gutter-size="3">
        <SplitterPanel :size="15" :min-size="10">
          <LeftNavigationMenu />
        </SplitterPanel>
        <SplitterPanel
          :size="85"
          :min-size="50"
          class="p-2"
          style="overflow-y: scroll"
        >
          <RouterView />
        </SplitterPanel>
      </Splitter>
    </SplitterPanel>
    <SplitterPanel :size="4" :min-size="3" class="p-0">
      <TerminalEmulator></TerminalEmulator>
    </SplitterPanel>
  </Splitter>

  <!-- Here we can create footer -->
</template>

<style scoped></style>
