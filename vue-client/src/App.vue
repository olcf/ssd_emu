<script setup>
import { RouterView } from 'vue-router'
import LeftNavigationMenu from './components/LeftNavigation/LeftNavigationMenu.vue'
</script>

<template>
  <!-- Here we can create header -->
  <Splitter layout="vertical" class="h-screen">
    <SplitterPanel :min-size="30">
      <Splitter :gutter-size="3">
        <SplitterPanel :size="10" :min-size="10">
          <LeftNavigationMenu />
        </SplitterPanel>
        <SplitterPanel :min-size="50" class="p-2">
          <RouterView />
        </SplitterPanel>
      </Splitter>
    </SplitterPanel>
    <SplitterPanel :min-size="15" class="p-2">
      <pre>
// this is just sample part
ssh firstMachine
    Logged into firstMachine
sbatch cpp_job.sbatch
    Running first Job
      </pre>
    </SplitterPanel>
  </Splitter>

  <!-- Here we can create footer -->
</template>

<style scoped></style>
