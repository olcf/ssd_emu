<template>
  <!-- REVIEW: Change this code to separate place or make it as a component -->
  <Dialog :visible="CREATE_NEW_JOB" modal maximizable>
    <template #header>
      <span class="font-bold text-xl">
        {{ 'Create a New Job for ' + machine.name }}</span
      >
    </template>
    <Form @submit.prevent="onConfirmCreateJob" class="flex flex-col">
      <div class="flex flex-wrap gap-12">
        <!-- Job NAME -->
        <div class="flex flex-col gap-2">
          <label for="job-project-name">Enter Project Name</label>
          <Select
            id="job-project-name"
            v-model="newJob.project_name"
            :options="projects"
            optionLabel="name"
            placeholder="Select a Project"
          />
        </div>

        <!-- Job Nodes -->
        <div class="flex flex-col gap-2">
          <label for="job-nodes">Enter number of Nodes to use</label>
          <InputNumber
            id="job-nodes"
            input-id="integeronly"
            :min="1"
            :max="machine.nodes"
            :use-grouping="false"
            v-model="newJob.nodes"
          />
        </div>

        <!-- Job Time -->
        <div class="flex flex-col gap-2">
          <label for="job-walltime">Enter time to allocate for the job</label>
          <InputNumber
            id="job-walltime"
            input-id="integeronly"
            :min="1"
            :max="86400"
            suffix=" sec"
            :use-grouping="false"
            v-model="newJob.walltime"
          />
          <small
            >Time: {{ convertToHoursMinutesSeconds(newJob.walltime) }}</small
          >
        </div>

        <!-- Job Mail Type -->
        <div class="flex flex-col gap-2">
          <label for="job-mail-type">Type of trigger sending email</label>
          <MultiSelect
            v-model="newJob.mail_type"
            :options="VALID_MAIL_TYPE"
            optionLabel="label"
            placeholder="Select Mail Type"
            filter
            :maxSelectedLabels="VALID_MAIL_TYPE.length - 1"
          ></MultiSelect>
        </div>

        <!-- Job Mail User -->
        <div class="flex flex-col gap-2">
          <label for="job-mail-user">Enter the email to send email</label>
          <InputText
            v-model="newJob.mail_user"
            placeholder="mail@example.com"
          ></InputText>
        </div>
      </div>

      <div class="flex flex-col">
        <span class="text-xl font-bold">Write script for the file here</span>
        <!-- Job Script -->
        <!-- TODO: Implement code/preview script component -->
        <Textarea></Textarea>
        <Textarea></Textarea>
      </div>

      <Button class="m-3" icon="pi pi-hammer" label="Create your Job" />
    </Form>
    <!-- TODO: implement uploading a new job -->
    <template #footer>
      <Button
        label="Cancel"
        text
        severity="secondary"
        @click="CREATE_NEW_JOB = false"
        icon="pi pi-times"
      ></Button>
      <Button
        label="Create your Job"
        @click="CREATE_NEW_JOB = false"
        icon="pi pi-save"
      ></Button>
    </template>
  </Dialog>
  <div class="flex justify-center">
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
      @click="CREATE_NEW_JOB = true"
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
      <Column field="id" header="Job Id"></Column>
      <Column field="project_name" header="Project Name"></Column>
      <Column field="nodes" header="Nodes"></Column>
      <Column field="script" header="Script">
        <template #body>
          <Button
            icon="pi pi-file-edit"
            rounded
            raised
            v-tooltip.bottom="'View and Edit the Script'"
          />
        </template>
      </Column>
      <Column field="walltime" header="walltime"></Column>
      <Column field="cores" header="cores"></Column>
      <Column field="state" header="state"></Column>
      <Column field="job_reason_code" header="Job Reason Code"></Column>
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
            /><Button
              v-else
              icon="pi pi-pause"
              v-tooltip.bottom="'Stop this Job'"
              rounded
              raised
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
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'SingleMachine',
  data() {
    return {
      CREATE_NEW_JOB: false,
      VALID_MAIL_TYPE: [
        { label: 'BEGIN' },
        { label: 'END' },
        { label: 'FAIL' },
        { label: 'REQUEUE' },
        { label: 'INVALID_DEPEND' },
        { label: 'STAGE_OUT' },
        { label: 'ALL' },
      ],
      machine: {},
      jobs: [],
      newJob: {
        mail_type: null,
      },
      projects: [],
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
    convertToHoursMinutesSeconds: function (time) {
      if (!time) {
        return '0 sec'
      } else {
        const hour = Math.floor(time / 3600)
        const minutes = Math.floor((time - hour * 3600) / 60)
        const seconds = Math.floor(time - hour * 3600 - minutes * 60)

        return (
          hour.toString().padStart(2, '0') +
          ':' +
          minutes.toString().padStart(2, '0') +
          ':' +
          seconds.toString().padStart(2, '0') +
          ' (hh:mm:ss)'
        )
      }
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
