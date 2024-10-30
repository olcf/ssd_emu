<script setup>
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { RouterView } from 'vue-router'
const menuItems = [
  {
    label: 'Machines',
    icon: 'pi pi-microchip-ai',
    items: [
      {
        label: 'Create a machine',
        icon: 'pi pi-plus',
      },
    ],
  },
]
</script>

<template>
  <!-- Here we can create header -->
  <Splitter layout="vertical" class="h-screen">
    <SplitterPanel :min-size="30">
      <Splitter :gutter-size="3">
        <SplitterPanel :size="10" :min-size="10">
          <!-- This will serve as user top menu and won't change when changing router -->
          <div class="menu p-2">
            <div class="flex justify-between">
              <span>
                <img src="./assets/images/logo.png" class="h-12" />
              </span>
              <Button>
                <FontAwesomeIcon icon="fa-regular fa-user" />
              </Button>
            </div>
          </div>
          <PanelMenu :model="menuItems"></PanelMenu>
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
