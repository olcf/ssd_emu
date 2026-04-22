<script setup>
import { ref, onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { api } from '@/apis'

const userStore = useUserStore()

const highlights = ref({
  machines: 0,
  jobs: 0,
  missions: 0,
})

onMounted(async () => {
  try {
    const [machines, jobs, missions] = await Promise.all([
      api.Machine.getAllMachines(),
      api.Job.getAllJobs(),
      api.Mission.getAllMissions(),
    ])
    highlights.value = {
      machines: machines.length,
      jobs: jobs.length,
      missions: missions.length,
    }
  } catch (_) {
    // keep defaults
  }
})

const quickLinks = [
  { label: 'Go to Machines', route: '/machines/all', icon: 'pi pi-microchip-ai' },
  { label: 'Go to Missions', route: '/mission/1', icon: 'pi pi-bullseye' },
  { label: 'Create a machine', route: '/createNewMachine', icon: 'pi pi-plus' },
]
</script>

<template>
  <main class="space-y-6">
    <h1 class="text-2xl font-bold text-surface-700 dark:text-surface-0">Dashboard</h1>

    <!-- Information about EMU -->
    <Panel header="About EMU">
      <p class="text-surface-700 dark:text-surface-0">
        EMU is a simulation software designed to show the architecture and operational mechanics
        of supercomputers used at Oak Ridge National Laboratory. It helps beginners learn job
        submission, queue systems, and schedulers in an HPC environment before using real systems.
      </p>
      <ul class="mt-2 text-surface-600 dark:text-surface-300 text-sm list-disc list-inside space-y-1">
        <li>Customizable machine creation with GPUs and CPUs</li>
        <li>SSH-style access to each machine</li>
        <li>Job creation and execution using SLURM</li>
        <li>Graphical and command-line support for jobs</li>
        <li>Run MPI applications</li>
        <li>Missions for step-by-step learning</li>
      </ul>
    </Panel>
    
        <!-- User info -->
    <Panel header="User info">
      <div class="flex flex-col gap-1 text-surface-700 dark:text-surface-0">
        <p><strong>Username:</strong> {{ userStore.getUsername }}</p>
        <p v-if="userStore.getFullName"><strong>Name:</strong> {{ userStore.getFullName }}</p>
        <p v-if="userStore.getEmail"><strong>Email:</strong> {{ userStore.getEmail }}</p>
        <p v-if="userStore.getUserRole"><strong>Role:</strong> {{ userStore.getUserRole }}</p>
      </div>
    </Panel>

    <!-- highlights -->
    <Panel header="Highlights">
      <div class="flex flex-wrap gap-4">
        <div class="flex items-center gap-2">
          <i class="pi pi-microchip-ai text-2xl text-primary" />
          <span><strong>{{ highlights.machines }}</strong> machines</span>
        </div>
        <div class="flex items-center gap-2">
          <i class="pi pi-list text-2xl text-primary" />
          <span><strong>{{ highlights.jobs }}</strong> jobs</span>
        </div>
        <div class="flex items-center gap-2">
          <i class="pi pi-bullseye text-2xl text-primary" />
          <span><strong>{{ highlights.missions }}</strong> missions</span>
        </div>
      </div>
    </Panel>

    <Panel header="Quick access">
      <div class="flex flex-wrap gap-2">
        <RouterLink v-for="link in quickLinks" :key="link.route" :to="link.route">
          <Button :icon="link.icon" :label="link.label" class="mr-2" />
        </RouterLink>
      </div>
    </Panel>

  </main>
</template>
