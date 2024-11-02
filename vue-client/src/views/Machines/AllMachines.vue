<template>
  <div class="flex align-center justify-center text-4xl underline py-6">
    Machines
  </div>
  <DataTable :value="machines" scrollable>
    <template #header>
      <div class="flex items-center flex-wrap justify-between gap-2">
        <span class="text-xl font-bold"> List of machines created by you </span>
        <span>
          <Button
            icon="pi pi-refresh"
            rounded
            raised
            @click="loadAllMachines"
          />
        </span>
      </div>
    </template>
    <Column field="name" header="Machine Name">
      <template #body="slotProps">
        <RouterLink :to="'/machines/' + slotProps.data.id" class="underline">{{
          slotProps.data.name
        }}</RouterLink>
      </template>
    </Column>
    <Column field="storage" header="Storage">
      <template #body="slotProps">
        {{ (slotProps.data.storage / 1024).toFixed(2) }} GB
      </template>
    </Column>
    <Column field="cores" header="Number of Cores"></Column>
    <Column field="cpus" header="Number of CPUs"></Column>
    <Column field="nodes" header="Number of Nodes"></Column>
    <Column field="gpus" header="Cores"></Column>
    <Column field="modules_list" header="Modules List">
      <template #body>
        <Button icon="pi pi-file" rounded raised />
      </template>
    </Column>
    <Column field="created_at" header="Created At">
      <template #body="slotProps">{{
        new Date(slotProps.data.created_at).toLocaleString()
      }}</template>
    </Column>
    <Column field="updated_at" header="Updated At">
      <template #body="slotProps">{{
        new Date(slotProps.data.updated_at).toLocaleString()
      }}</template>
    </Column>
  </DataTable>
</template>
<script>
import { api } from '@/apis'
import { defineComponent } from 'vue'
import { RouterLink } from 'vue-router'

export default defineComponent({
  name: 'AllMachines',
  components: {
    RouterLink,
  },

  data() {
    return {
      machines: [],
    }
  },
  async mounted() {
    await this.loadAllMachines()
  },
  methods: {
    async loadAllMachines() {
      const allMachines = await api.Machine.getAllMachines()
      this.machines = allMachines
    },
  },
})
</script>
