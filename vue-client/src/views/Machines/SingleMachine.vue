<template>
  <div class="flex justify-center">
    <Dialog
      maximizable
      v-model:visible="VIEW_SCRIPT"
      modal
      header="Preview your script"
      :style="{ width: '80rem' }"
    >
      <StyleldScript :job="jobs[CURRENT_VIEWING_ID]"></StyleldScript>
    </Dialog>
    <Dialog
      maximizable
      v-model:visible="VIEW_EXECUTION"
      modal
      header="View the output of your script"
      :style="{ width: '80rem' }"
    >
      <StyledOutput
        :output="selectedJob.output"
        :error="selectedJob.error"
      ></StyledOutput>
    </Dialog>
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
  </div>
  <div class="p-10 flex gap-10">
    <Button
      icon="pi pi-plus"
      iconPos="top"
      label="Create new Job"
      class="max-w-64"
      @click="navigateToCreateNewJob"
    >
      <i class="pi pi-plus"></i>
      <span>Create a Job</span>
      <small>
        Create a new job for this machine. You can alternatively use `this
        command` to do manually through command line.</small
      >
    </Button>
  </div>
  <div class="p-10 flex gap-10">
    <DataTable
      :value="jobs"
      tableStyle="min-width: 50rem"
      scrollable
      scrollHeight="400px"
    >
      <template #header>
        <div class="flex flex-wrap items-center justify-between gap-2">
          <span class="text-xl font-bold">List of Jobs</span>
          <div class="flex gap-4">
            <Button
              icon="pi pi-plus"
              rounded
              raised
              v-tooltip.bottom="'Create a new Job'"
            />

            <Button
              icon="pi pi-refresh"
              rounded
              raised
              @click="updateNecessaryData"
              tooltip="Refresh"
              v-tooltip.bottom="'Refresh jobs list'"
            />
          </div>
        </div>
      </template>
      <Column field="name" header="Job Name"></Column>
      <Column field="project_name" header="Project Name"></Column>
      <Column field="nodes" header="Nodes"></Column>
      <Column field="script" header="Script">
        <template #body="slotProps">
          <Button
            icon="pi pi-file-edit"
            rounded
            raised
            v-tooltip.bottom="'View and Edit the Script'"
            @click="viewScriptClicked(slotProps.data.id)"
          />
        </template>
      </Column>
      <Column field="walltime" header="walltime"></Column>
      <Column field="cores" header="cores"></Column>
      <Column field="slurm_cores" header="Slurm Cores"></Column>
      <Column field="state" header="state"></Column>
      <Column field="job_reason_code" header="Job Reason Code"></Column>
      <Column field="out_file" header="Output File">
        <template #body="slotProps">
          {{ slotProps.data.out_file || 'STDOUT' }}
        </template>
      </Column>
      <Column field="err_file" header="Error File">
        <template #body="slotProps">
          {{ slotProps.data.err_file || 'STDERR' }}
        </template>
      </Column>
      <Column field="created_at" header="Created">
        <template #body="slotProps">
          {{ formatDate(slotProps.data.created_at) }}
        </template>
      </Column>
      <Column field="updated_at" header="Updated">
        <template #body="slotProps">
          {{ formatDate(slotProps.data.updated_at) }}
        </template></Column
      >
      <Column header="Actions">
        <template #body="slotProps">
          <span class="flex gap-1">
            <Button
              v-if="slotProps.data.state !== 'R'"
              icon="pi pi-play"
              rounded
              v-tooltip.bottom="'Run this Job'"
              @click="runJob(slotProps.data.id)"
            /><Button
              v-else
              icon="pi pi-pause"
              v-tooltip.bottom="'Stop this Job'"
              rounded
              raised
            />
            <Button
              icon="pi pi-eye"
              rounded
              v-tooltip.bottom="'View the execution'"
              @click="viewExecution(slotProps.data.id)"
            />
            <Button
              icon="pi pi-pencil"
              v-tooltip.bottom="'Edit this Job'"
              rounded
              raised
            />
            <Button
              icon="pi pi-times"
              severity="danger"
              v-tooltip.bottom="'Cancel this job'"
              rounded
              raised
            />
          </span>
        </template>
      </Column>
    </DataTable>
  </div>
</template>

<script>
import { api } from '@/apis'
import StyleldScript from '@/components/Jobs/StyleldScript.vue'
import StyledOutput from '@/components/Jobs/StyledOutput.vue'
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'SingleMachine',
  components: { StyleldScript, StyledOutput },
  data() {
    return {
      VIEW_SCRIPT: false,
      VIEW_EXECUTION: false,
      CURRENT_VIEWING_ID: null,
      machine: {},
      jobs: [],
      // selected job is used to store data for any actions pressed in specific job.
      selectedJob: {
        output: null,
        error: null,
      },
    }
  },
  created: async function () {
    await this.updateNecessaryData()

    // since, we don't need to update project name on every other machine, we will be loading projects only once
    const allProjects = await api.Project.getAllProjects()
    this.projects = allProjects
  },
  // here we are watching route id so that we can update the UI accordingly
  watch: {
    // eslint-disable-next-line no-unused-vars
    async '$route.params.id'(to, from) {
      await this.updateNecessaryData()
    },
  },
  methods: {
    onConfirmCreateJob: async function () {},
    viewScriptClicked: function (id) {
      this.VIEW_SCRIPT = true
      this.CURRENT_VIEWING_ID = this.jobs.findIndex(job => job.id === id)
    },
    runJob: async function (jobId) {
      await api.Job.run(jobId)
    },
    // When we view the execution, we will pull out modal window where we will display either output or error found in the script.
    // If it is empty, we will just say, 'You have to run the script to see the output'
    viewExecution: async function (jobId) {
      try {
        const singleJobRequest = await api.Job.getById(jobId)
        const singleJob = await singleJobRequest.data
        this.VIEW_EXECUTION = true

        // If output is empty, we are going to show error
        if (singleJob.out) {
          this.selectedJob.output = singleJob.out
          this.selectedJob.error = null
        } else {
          this.selectedJob.output = null
          this.selectedJob.error = singleJob.err
        }
      } catch (error) {
        // REVIEW: Add mechanism to show the toast warning!
        alert('Error found' + error)
      }
    },
    updateNecessaryData: async function () {
      const machineDetails = await api.Machine.getMachine(this.$route.params.id)
      this.machine = machineDetails

      const allJobsForThisMachine = await api.Job.getAllJobsForMachine(
        this.machine.id,
      )
      this.jobs = allJobsForThisMachine
    },
    formatDate: function (date) {
      const givenDate = new Date(date)
      return givenDate.toLocaleString()
    },
    navigateToCreateNewJob: function () {
      this.$router.push({
        name: 'CreateNewJob',
        query: {
          machine: this.machine.name,
          nodes: this.machine.nodes,
          cores: this.machine.cores,
        },
      })
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
