<template>
  <div class="h-12"></div>
  <div class="flex flex-wrap gap-12">
    <!-- MACHINE NAME -->
    <div class="flex flex-col gap-2">
      <label for="machine-name">Enter Machine Name</label>
      <InputText id="machine-name" type="text" v-model="machineData.name" />
    </div>

    <!-- MACHINE STORAGE -->
    <div class="flex flex-col gap-2">
      <label for="machine-storage">Enter Machine Storage</label>
      <InputNumber
        id="machine-storage"
        input-id="minmaxfraction"
        :min="100"
        :max="9999999.99"
        :max-fraction-digits="2"
        :use-grouping="true"
        suffix=" MB"
        v-model="machineData.storage"
      />
      <small id="machine-storage-help"
        >Approx. {{ (machineData.storage / 1024).toFixed(2) }} GB</small
      >
    </div>

    <!-- MACHINE NODES -->
    <div class="flex flex-col gap-2">
      <label for="machine-nodes">Enter Number of Nodes for the machine</label>
      <InputNumber
        id="machine-nodes"
        input-id="integeronly"
        :min="1"
        :max="20000"
        :use-grouping="false"
        v-model="machineData.nodes"
      />
    </div>

    <!-- MACHINE CPUS -->
    <div class="flex flex-col gap-2">
      <label for="machine-cpus">Enter Number of CPUs for the machine</label>
      <InputNumber
        id="machine-cpus"
        input-id="integeronly"
        :min="1"
        :max="16"
        :use-grouping="false"
        v-model="machineData.cpus"
      />
    </div>

    <!-- MACHINE CORES -->
    <div class="flex flex-col gap-2">
      <label for="machine-cores">Enter Number of Cores for each CPU</label>
      <InputNumber
        id="machine-cores"
        input-id="integeronly"
        :min="1"
        :max="128"
        :use-grouping="false"
        v-model="machineData.cores"
      />
    </div>

    <!-- MACHINE GPUs -->
    <div class="flex flex-col gap-2">
      <label for="machine-gpus">Enter Number of GPUs for each Node</label>
      <InputNumber
        id="machine-gpus"
        input-id="integeronly"
        :min="1"
        :max="16"
        :use-grouping="false"
        v-model="machineData.gpus"
      />
    </div>
  </div>
  <Button
    class="m-3"
    icon="pi pi-hammer"
    label="Build Your Machine"
    @click="onConfirmCreateMachine"
  />
</template>

<script>
import { ref } from 'vue'
import { useConfirm } from 'primevue/useconfirm'
import { api } from '@/apis'

export default {
  setup() {
    const machineData = ref({
      name: '',
      storage: 100,
      cores: 1,
      cpus: 1,
      nodes: 1,
      gpus: 1,
      modules_list: [],
    })
    const confirmCreateMachine = useConfirm()

    return {
      machineData,
      confirmCreateMachine,
    }
  },
  methods: {
    handleConfirmation: async function () {
      // Call Rails API
      const newMachine = await api.Machine.create(this.machineData)
      // :name, :storage, :cores, :cpus, :nodes, :gpus, :modules_list
      console.log(newMachine)
    },
    onConfirmCreateMachine: function () {
      this.confirmCreateMachine.require({
        message: 'Are you sure you want to proceed?',
        header: 'Machine Creation Confirmation',
        icon: 'pi pi-question-circle',
        acceptIcon: 'pi pi-save',
        rejectIcon: 'pi pi-times',
        accept: this.handleConfirmation,
      })
    },
  },
}
</script>
