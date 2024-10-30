<script setup>
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
const menuItems = [
  {
    label: 'Machines',
    icon: 'pi pi-microchip-ai',
    items: [
      {
        label: 'Create a machine',
        icon: 'pi pi-plus',
        route: '/createNewMachine',
      },
    ],
  },
]
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
