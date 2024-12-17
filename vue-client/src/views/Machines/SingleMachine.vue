<template>
  <div class="flex justify-center">
    <Dialog
      maximizable
      v-model:visible="VIEW_SCRIPT"
      modal
      header="Preview your script"
      :style="{ width: '80rem' }"
    >
      <StyledScript
        v-if="CURRENT_VIEWING_ID != null"
        :job="jobs[CURRENT_VIEWING_ID]"
      ></StyledScript>
    </Dialog>
    <Dialog
      maximizable
      v-model:visible="VIEW_EXECUTION"
      modal
      header="View the output of your script"
      :style="{ width: '80rem' }"
    >
      <StyledOutput
        v-if="CURRENT_VIEWING_ID != null"
        :job="jobs[CURRENT_VIEWING_ID]"
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
      <Column field="name" header="Job Name">
        <template #body="slotProps">
          <RouterLink
            :to="'/machine/' + machine.id + '/job/' + slotProps.data.id"
            class="underline"
            >{{ slotProps.data.name }}</RouterLink
          >
        </template>
      </Column>
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
            <!-- If job doesn't have state of Running or Pending, just show run this job button else pause button -->
            <Button
              v-if="!['R', 'PD'].includes(slotProps.data.state)"
              icon="pi pi-play"
              rounded
              v-tooltip.bottom="'Run this Job'"
              @click="runJob(slotProps.data.id)"
            /><Button
              v-else
              icon="pi pi-spin pi-spinner"
              v-tooltip.bottom="'Stop this Job'"
              rounded
              @click="stopJob(slotProps.data.id)"
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
              icon="pi pi-trash"
              severity="danger"
              v-tooltip.bottom="'Delete this job'"
              rounded
              raised
              @click="deleteJob(slotProps.data.id)"
            />
          </span>
        </template>
      </Column>
    </DataTable>
  </div>
</template>

<script>
import { api } from '@/apis'
import StyledScript from '@/components/Jobs/StyledScript.vue'
import StyledOutput from '@/components/Jobs/StyledOutput.vue'
import { defineComponent } from 'vue'
import { useConfirm } from 'primevue/useconfirm'

export default defineComponent({
  name: 'SingleMachine',
  components: { StyledScript, StyledOutput },
  setup() {
    const confirmDeleteMachine = useConfirm()
    return { confirmDeleteMachine }
  },
  data() {
    return {
      VIEW_SCRIPT: false,
      VIEW_EXECUTION: false,
      CURRENT_VIEWING_ID: null,
      machine: {},
      jobs: [],
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
    getExecutionIcon: function (jobState) {
      let icon = 'pi '
      if (jobState === 'R' || jobState === 'PD') {
        icon += 'pi-spin pi-spinner'
      } else {
        icon += 'pi-play'
      }
      return icon
    },
    onConfirmCreateJob: async function () {},
    viewScriptClicked: function (id) {
      this.VIEW_SCRIPT = true
      this.CURRENT_VIEWING_ID = this.jobs.findIndex(job => job.id === id)
    },
    runJob: async function (jobId) {
      try {
        const job = await api.Job.run(jobId)
        this.CURRENT_VIEWING_ID = this.jobs.findIndex(job => job.id === jobId)
        this.jobs[this.CURRENT_VIEWING_ID] = job

        this.$toast.add({
          severity: 'success',
          summary: 'Success Message',
          detail: 'Job scheduled to run',
          life: 3000,
        })
      } catch (error) {
        this.$toast.add({
          severity: 'warn',
          summary: 'Warn Message',
          detail: "Couldn't run the job! " + error,
          life: 3000,
        })
      }
    },
    stopJob: async function (jobId) {
      // TODO: implement stop job process.
      try {
        this.$toast.add({
          severity: 'success',
          summary: 'Success Message',
          detail: 'Stop request sent for the job sent.',
          life: 3000,
        })
      } catch (error) {
        this.$toast.add({
          severity: 'warn',
          summary: 'Warn Message',
          detail: "Couldn't stop the job! " + error,
          life: 3000,
        })
      }
    },
    deleteJob: async function (jobId) {
      try {
        this.confirmDeleteMachine.require({
          message: 'Are you sure you want to delete this job?',
          header: 'Confirmation',
          icon: 'pi pi-exclamation-triangle',
          accept: async () => {
            await api.Job.deleteById(jobId)
            const deletedJobId = this.jobs.findIndex(job => job.id == jobId)
            // delete the job from jobs array
            this.jobs.splice(deletedJobId, 1)
            this.$toast.add({
              severity: 'success',
              summary: 'Success Message',
              detail: 'Job deleted successfully!',
              life: 3000,
            })
          },
          reject: () => {
            this.$toast.add({
              severity: 'info',
              summary: 'Info Message',
              detail: 'You canceled to delete the job!',
              life: 3000,
            })
          },
        })
      } catch (error) {
        this.$toast.add({
          severity: 'error',
          summary: 'Error Message',
          detail: "Couldn't delete the Job! " + error,
          life: 3000,
        })
      }
    },
    // When we view the execution, we will pull out modal window where we will display either output or error found in the script.
    // If it is empty, we will just say, 'You have to run the script to see the output'
    viewExecution: async function (jobId) {
      try {
        const singleJob = await api.Job.getById(jobId)
        this.CURRENT_VIEWING_ID = this.jobs.findIndex(job => job.id === jobId)
        this.jobs[this.CURRENT_VIEWING_ID] = singleJob

        // ready to show the dialog
        this.VIEW_EXECUTION = true
      } catch (error) {
        this.$toast.add({
          severity: 'warn',
          summary: 'Warn Message',
          detail: "Couldn't fetch updated job! " + error,
          life: 3000,
        })
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
