<script setup>
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { useUserStore } from '@/stores/user'
import { onMounted, ref } from 'vue'
import { api } from '@/apis'
const menuItems = ref([
  {
    label: 'Machines',
    icon: 'pi pi-microchip-ai',
    items: [],
  },
  {
    label: 'List all machines',
    icon: 'pi pi-eye',
    route: '/machines/all',
  },
  {
    label: 'Missions',
    icon: 'pi pi-bullseye',
    items: [
      {
        label: 'Understand basics of HPC',
        route: '/missions/understandBasicsHPC',
      },
      {
        label: 'Understand basics architecture of machine',
        route: '/missions/understandArchitecture',
      },
      {
        label: 'Login to two different machines',
      },
      {
        label: 'Create a new job',
      },
      {
        label: 'Run a job from both GUI and CLI',
      },
      {
        label: 'Create jobs for different scenarios',
      },
      {
        label: 'Loading modules',
      },
      {
        label: 'Final mission',
      },
    ],
  },
])
const userStore = useUserStore()
onMounted(async () => {
  const machines = await api.Machine.getAllMachines()
  machines.forEach(element => {
    element.label = element.name
    element.icon = 'pi pi-microchip-ai'
    element.route = '/machine/' + element.id
  })
  machines.unshift({
    label: 'Create a machine',
    icon: 'pi pi-plus',
    route: '/createNewMachine',
  })
  menuItems.value[0].items = machines

  // add all missions to menu items
  const allMissions = await api.Mission.getAllMissions()
  allMissions.forEach(mission => {
    mission.icon = 'pi pi-bullseye'
    mission.label = mission.title
    mission.route = '/mission/' + mission.id
  })
  menuItems.value[2].items = allMissions

  // Add Columns if User is Admin
  const adminItems = [{
    label: 'Edit Chapter',
    route: '/admin/editChapter'
  }]

  if(userStore.getUserRole == 'admin')
  {
    menuItems.value.push({
    icon: 'pi pi-shield',
    label: 'Admin',
    items: adminItems
  })
  }


})
</script>

<template>
  <!-- This will serve as user top menu and won't change when changing router -->
  <div class="menu p-2">
    <div class="flex justify-between">
      <span>
        <img src="@/assets/images/logo.png" class="h-12" />
      </span>
      <Button>
        <FontAwesomeIcon icon="fa-regular fa-user" />
        {{ userStore.username }}
      </Button>
    </div>
  </div>
  <PanelMenu :model="menuItems">
    <!-- This code is for rendering specific menu item so we are using slot -->
    <template #item="{ item }">
      <!-- If there is route present, just render the route else just show the text in button style -->
      <RouterLink
        v-if="item.route"
        :to="item.route"
        class="flex items-center cursor-pointer text-surface-700 dark:text-surface-0 px-4 py-2"
      >
        <span :class="item.icon" />
        <span class="ml-2">{{ item.label }}</span>
      </RouterLink>
      <span
        v-else
        v-ripple
        class="flex items-center cursor-pointer text-surface-700 dark:text-surface-0 px-4 py-2"
      >
        <span :class="item.icon" />
        <span class="ml-2">{{ item.label }}</span>
        <span v-if="item.items" class="pi pi-angle-down text-primary ml-auto" />
      </span>
    </template>
  </PanelMenu>
</template>
