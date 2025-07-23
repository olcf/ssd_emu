<script setup>
import { onMounted, ref } from 'vue'
import { RouterView } from 'vue-router'
import LeftNavigationMenu from './components/LeftNavigation/LeftNavigationMenu.vue'
import { useUserStore } from './stores/user'
import { useCLIStore} from './stores/commandLine'
import TerminalEmulator from './components/Terminal/TerminalEmulator.vue'
import XtermTerminal from '@/components/Terminal/XtermTerminal.vue'


const userStore = useUserStore()
const machineStore = useCLIStore()
const isLoggedIn = ref(false)

onMounted(async () => {
  console.log('App.vue: Starting user login...')
  await userStore.login()
  console.log('App.vue: User login completed. User ID:', userStore.getUserId)
  isLoggedIn.value = true
})
</script>

<template>
  <!-- Show loading until login is complete -->
  <div v-if="!isLoggedIn" class="h-screen flex items-center justify-center bg-gray-900">
    <div class="text-center">
      <i class="pi pi-spin pi-spinner text-4xl text-blue-400 mb-4"></i>
      <p class="text-gray-300">Loading...</p>
      <p class="text-gray-300">Logging in User...</p>

    </div>
  </div>

  <!-- Render app only after login is complete -->
  <div v-else>
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
        <!-- If there exists a machine in CLI store, then show xterm, else show Regular Terminal -->
        <XtermTerminal v-if="machineStore.hasValidMachine" />
         <TerminalEmulator v-else/>
      </SplitterPanel>
    </Splitter>
  </div>

  <!-- Here we can create footer -->
</template>

<style scoped></style>
