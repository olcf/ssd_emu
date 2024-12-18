<template>
  <span class="font-bold text-xl">
    {{ 'Edit Job "' + this.editJob.name + '"' }}</span
  >
  <Form @submit.prevent="onConfirmEditJob" class="flex flex-col">
    <div class="flex flex-wrap gap-12">
      <!-- Job NAME -->
      <div class="flex flex-col gap-2">
        <label for="job-name">Enter the name of the Job</label>
        <InputText id="job-name" v-model="editJob.name"></InputText>
      </div>

      <div class="flex flex-col gap-2">
        <label for="job-project-name">Enter Project Name</label>
        <Select
          id="job-project-name"
          v-model="editJob.project"
          :options="projects"
          optionLabel="name"
          placeholder="Select a Project"
        />
      </div>

      <!-- Job Output File-->
      <div class="flex flex-col gap-2">
        <label for="job-name">Enter output file name</label>
        <InputText id="job-err-file" v-model="editJob.out_file"></InputText>
      </div>

      <!-- Job Error File -->
      <div class="flex flex-col gap-2">
        <label for="job-name">Enter error file name</label>
        <InputText id="job-out-file" v-model="editJob.err_file"></InputText>
      </div>

      <!-- Job Nodes -->
      <div class="flex flex-col gap-2">
        <label for="job-nodes">Enter number of Nodes to use</label>
        <InputNumber
          id="job-nodes"
          input-id="integeronly"
          :min="1"
          :use-grouping="false"
          v-model="editJob.nodes"
        />
        <small v-if="editJob.nodes > this.machine.nodes"
          >Looks like you are requesting nodes more than available!</small
        >
      </div>

      <!-- Job Cores -->
      <div class="flex flex-col gap-2">
        <label for="job-cores">Enter number of Cores to use</label>
        <InputNumber
          id="job-cores"
          input-id="integeronly"
          :min="1"
          :max="this.machine.cores"
          :use-grouping="false"
          v-model="editJob.cores"
        />
      </div>

      <!-- Number of Slurm Cores -->
      <div class="flex flex-col gap-2">
        <label for="job-cores">Enter number of Slurm Cores to use</label>
        <InputNumber
          id="job-slurm-cores"
          input-id="integeronly"
          :min="1"
          :max="this.machine.cores"
          :use-grouping="false"
          v-model="editJob.slurm_cores"
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
          v-model="editJob.walltime"
        />
        <small>Time: {{ formattedTime + ' (hh:mm:ss)' }}</small>
      </div>

      <!-- Job Mail Type -->
      <div class="flex flex-col gap-2">
        <label for="job-mail-type">Type of trigger sending email</label>
        <!-- TODO: update email list on script with update here -->
        <MultiSelect
          v-model="mail_type"
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
          v-model="editJob.mail_user"
          placeholder="mail@example.com"
        ></InputText>
      </div>
    </div>
    <div class="flex flex-col">
      <span class="text-xl font-bold">Script File</span>
      <!-- Job Script -->
      <!-- TODO: Implement code/preview script component -->
      <Splitter class="min-h-64">
        <SplitterPanel class="flex flex-col">
          <span class="p-2 text-center text-xl font-bold">
            Edit your Script here
          </span>
          <textarea
            v-model="editJob.script"
            class="p-2 resize-none h-full"
          ></textarea>
        </SplitterPanel>
        <SplitterPanel class="flex flex-col">
          <span class="p-2 text-center text-xl font-bold">
            Preview your Script here
          </span>
          <StyledScript :job="editJob"></StyledScript>
        </SplitterPanel>
      </Splitter>
    </div>
  </Form>

  <div class="p-3 text-right">
    <Button
      label="Cancel"
      text
      severity="secondary"
      icon="pi pi-times"
      @click="this.$router.back()"
    ></Button>
    <Button
      label="Edit your Job"
      icon="pi pi-save"
      @click="onConfirmEditJob"
    ></Button>
  </div>
</template>

<script>
import { api } from '@/apis'
import StyledScript from '@/components/Jobs/StyledScript.vue'
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'EditJob',
  components: {
    StyledScript,
  },
  data() {
    return {
      VALID_MAIL_TYPE: [
        { label: 'BEGIN' },
        { label: 'END' },
        { label: 'FAIL' },
        { label: 'REQUEUE' },
        { label: 'INVALID_DEPEND' },
        { label: 'STAGE_OUT' },
      ],
      editJob: {
        script_body: ``,
        project: null,
        nodes: '0',
        cores: '0',
        mail_type: '0',
        mail_user: '0',
        script: '0',
        project_id: '0',
        machine_id: '0',
        slurm_cores: '0',
        out_file: '0',
        walltime: '0',
        err_file: '0',
        name: '0',
      },
      mail_type: [],
      projects: [],
      machine: {},
    }
  },
  watch: {
    // eslint-disable-next-line no-unused-vars
    async '$route.params.jobId'(to, from) {
      await this.loadJob()
    },
  },
  computed: {
    mailTypeSeparatedByComma: function () {
      if (this.editJob.mail_type) {
        const mailTypes = this.editJob.mail_type
        if (mailTypes.length >= 6) {
          return 'ALL'
        } else {
          let allMailType = ''
          mailTypes.forEach(mailType => {
            allMailType += mailType.label + ','
          })
          allMailType = allMailType.slice(0, -1)
          return allMailType
        }
      } else {
        return ''
      }
    },
    formattedTime: function () {
      const givenTime = this.editJob.walltime
      if (!givenTime) {
        return '00:00:00'
      } else {
        const hour = Math.floor(givenTime / 3600)
        const minutes = Math.floor((givenTime - hour * 3600) / 60)
        const seconds = Math.floor(givenTime - hour * 3600 - minutes * 60)

        return (
          hour.toString().padStart(2, '0') +
          ':' +
          minutes.toString().padStart(2, '0') +
          ':' +
          seconds.toString().padStart(2, '0')
        )
      }
    },
  },
  created: async function () {
    // since, we don't need to update project name on every other machine, we will be loading projects only once
    const allProjects = await api.Project.getAllProjects()
    this.projects = allProjects
    this.machine.name = this.$route.query.machine
    this.machine.nodes = parseInt(this.$route.query.nodes)
    this.machine.cores = parseInt(this.$route.query.cores)
    await this.loadJob()
    // TODO: if machine.nodes and machine.name are not available, load the machine again.
  },
  methods: {
    loadJob: async function () {
      const toLoadJob = await api.Job.getById(this.$route.params.jobId)
      this.editJob = toLoadJob
      const splittedMail = this.editJob.mail_type.split(',') || []
      // update the mail type so that it follows primevue multiselect pattern
      // when All is selected, copy from valid types
      if (this.editJob.mail_type == 'ALL') {
        this.mail_type = this.VALID_MAIL_TYPE
      } else {
        this.mail_type = splittedMail.map(item => ({ label: item }))
      }
    },
    onConfirmEditJob: async function () {
      try {
        let sendingJob = {}
        sendingJob = this.editJob
        sendingJob.mail_type = this.mailTypeSeparatedByComma
        await api.Job.update(sendingJob)
        this.$toast.add({
          severity: 'success',
          summary: 'Success Message',
          detail: `Your job ${sendingJob.name} updated successfully.`,
          life: 3000,
        })
        this.$router.back()
      } catch (error) {
        this.$toast.add({
          severity: 'warn',
          summary: 'Warning Message',
          detail: `Couldn't create new Job  ${error}`,
          life: 3000,
        })
      }
    },
  },
})
</script>
