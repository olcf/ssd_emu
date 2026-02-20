import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import { useUserStore } from '@/stores/user'
// TODO: update homepage and re update components here
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
    {
      path: '/machine/:id/job/:jobId',
      name: 'SingleJob',
      component: () => import('@/views/Jobs/SingleJob.vue'),
    },
    {
      path: '/machine/:id/job/:jobId/edit',
      name: 'EditJob',
      component: () => import('@/views/Jobs/EditJob.vue'),
    },
    {
      path: '/mission/:id',
      name: 'SingleMission',
      component: () => import('@/views/Missions/SingleMission.vue'),
    },
    {
      path: '/mission/:missionId/chapter/:chapterId',
      name: 'SingleChapter',
      component: () => import('@/views/Missions/Chapters/SingleChapter.vue'),
    },
    {
      path: '/admin/editChapter',
      name: 'editChapter',
      component: ()=> import('@/views/admin/EditChapter.vue'),
      meta:{
        requiresAuth: true
      }
    }
  ],
})

router.beforeEach((to,from,next)=>{
  const userStore = useUserStore()
  // Return to Login if user is not admin
  if(to.meta.requiresAuth && userStore.getUserRole != 'admin'){
    next('/login')
  }else{
    next()
  }
})

export default router
