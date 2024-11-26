import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
    },
    {
      path: '/about',
      name: 'about',
      // route level code-splitting
      // this generates a separate chunk (About.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import('../views/AboutView.vue'),
    },
    {
      path: '/createNewMachine',
      name: 'createNewMachine',
      component: () => import('../views/Machines/CreateMachineView.vue'),
    },
    {
      path: '/machines/all',
      name: 'AllMachines',
      component: () => import('@/views/Machines/AllMachines.vue'),
    },
    {
      path: '/machine/:id',
      name: 'SingleMachine',
      component: () => import('@/views/Machines/SingleMachine.vue'),
    },
    {
      path: '/machine/:id/createNewJob',
      name: 'CreateNewJob',
      component: () => import('@/components/Machines/CreateNewJob.vue'),
    },
  ],
})

export default router
