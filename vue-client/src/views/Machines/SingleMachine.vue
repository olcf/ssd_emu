<template>
  <table class="text-left">
    <thead>
      <tr>
        <th scope="col">Fields</th>
        <th scope="col">Values</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <th>Machine Name</th>
        <td>{{ machine.name }}</td>
      </tr>
      <tr>
        <th>Storage in GB</th>
        <td>{{ (machine.storage / 1024).toFixed(2) }}</td>
      </tr>
      <tr>
        <th>Total Cores in one Node</th>
        <td>{{ machine.cores }}</td>
      </tr>
      <tr>
        <th>Total CPUs in Machine</th>
        <td>{{ machine.cpus }}</td>
      </tr>
      <tr>
        <th>Total Nodes in machine</th>
        <td>{{ machine.nodes }}</td>
      </tr>
      <tr>
        <th>Total GPUs in one Node</th>
        <td>{{ machine.gpus }}</td>
      </tr>
      <tr>
        <th>Total GPUs in machine</th>
        <td>node * gpu = {{ machine.nodes * machine.gpus }} GPUs</td>
      </tr>
      <tr>
        <th>Module List</th>
        <td>{{ machine.module_list }}</td>
      </tr>
    </tbody>
    <caption>
      Machine details
    </caption>
  </table>
</template>

<script>
import { api } from '@/apis'
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'SingleMachine',
  data() {
    return {
      machine: {},
    }
  },
  created: async function () {
    const machineDetails = await api.Machine.getMachine(this.$route.params.id)
    this.machine = machineDetails
  },
  // here we are watching route id so that we can update the UI accordingly
  watch: {
    async '$route.params.id'(to, from) {
      const machineDetails = await api.Machine.getMachine(this.$route.params.id)
      this.machine = machineDetails
    },
  },
})
</script>

<style scoped>
table,
td,
tr,
th {
  border: 1px solid beige;
  padding: 6px 10px;
}
</style>
