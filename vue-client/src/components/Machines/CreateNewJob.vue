<template>
  <span class="font-bold text-xl">
    {{ 'Create a New Job for ' + this.machine.name }}</span
  >

  <Form @submit.prevent="onConfirmCreateJob" class="flex flex-col">
    <div class="flex flex-wrap gap-12">
      <!-- Job NAME -->
      <div class="flex flex-col gap-2">
        <label for="job-name">Enter the name of the Job</label>
        <InputText id="job-name" v-model="newJob.name"></InputText>
      </div>

      <div class="flex flex-col gap-2">
        <label for="job-project-name">Enter Project Name</label>
        <Select
          id="job-project-name"
          v-model="newJob.project"
          :options="projects"
          optionLabel="name"
          placeholder="Select a Project"
        />
      </div>

      <!-- Job Output File-->
      <div class="flex flex-col gap-2">
        <label for="job-name">Enter output file name</label>
        <InputText id="job-err-file" v-model="newJob.out_file"></InputText>
      </div>

      <!-- Job Error File -->
      <div class="flex flex-col gap-2">
        <label for="job-name">Enter error file name</label>
        <InputText id="job-out-file" v-model="newJob.err_file"></InputText>
      </div>

      <!-- Job Nodes -->
      <div class="flex flex-col gap-2">
        <label for="job-nodes">Enter number of Nodes to use</label>
        <InputNumber
          id="job-nodes"
          input-id="integeronly"
          :min="1"
          :max="this.machine.nodes"
          :use-grouping="false"
          v-model="newJob.nodes"
        />
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
          v-model="newJob.cores"
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
          v-model="newJob.slurm_cores"
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
        <small>Time: {{ formattedTime + ' (hh:mm:ss)' }}</small>
      </div>

      <!-- Job Mail Type -->
      <div class="flex flex-col gap-2">
        <label for="job-mail-type">Type of trigger sending email</label>
        <MultiSelect
          v-model="newJob.mail.type"
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
          v-model="newJob.mail.user"
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
            v-model="newJob.script_body"
            class="p-2 resize-none h-full"
          ></textarea>
        </SplitterPanel>
        <SplitterPanel class="flex flex-col">
          <span class="p-2 text-center text-xl font-bold">
            Preview your Script here
          </span>
          <VCodeBlock
            highlightjs
            :code="combinedScript"
            lang="bash"
          ></VCodeBlock>
        </SplitterPanel>
      </Splitter>
    </div>
  </Form>
  <!-- TODO: implement uploading a new job -->
  <div class="p-3 text-right">
    <Button
      label="Cancel"
      text
      severity="secondary"
      icon="pi pi-times"
      @click="this.$router.back()"
    ></Button>
    <Button
      label="Create your Job"
      icon="pi pi-save"
      @click="onConfirmCreateJob"
    ></Button>
  </div>
</template>

<script>
import { api } from '@/apis'
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'CreateNewJob',
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
      newJob: {
        script_body: ``,
        project: null,
        mail: {
          user: null,
          type: null,
        },
      },
      projects: [],
      machine: {},
    }
  },
  computed: {
    combinedScript: function () {
      let topScriptPart = '#!/bin/bash\n\n'
      if (this.newJob.name) {
        topScriptPart += `#SBATCH -J ${this.newJob.name} \n`
      }
      if (this.newJob.project) {
        topScriptPart += `#SBATCH -A ${this.newJob.project.name} \n`
      }
      if (this.newJob.nodes) {
        topScriptPart += `#SBATCH -N ${this.newJob.nodes} \n`
      }
      if (this.newJob.cores) {
        topScriptPart += `#SBATCH --threads-per-core=${this.newJob.cores} \n`
      }
      if (this.newJob.slurm_cores) {
        topScriptPart += `#SBATCH -S ${this.newJob.slurm_cores} \n`
      }
      if (this.newJob.walltime) {
        topScriptPart += `#SBATCH -t ${this.formattedTime} \n`
      }
      if (this.newJob.mail.user) {
        topScriptPart += `#SBATCH --mail-user=${this.newJob.mail.user} \n`
      }
      if (this.newJob.mail.type) {
        topScriptPart += `#SBATCH --mail-type=${this.mailTypeSeparatedByComma} \n`
      }

      if (this.newJob.out_file) {
        topScriptPart += `#SBATCH -o ${this.newJob.out_file} \n`
      }
      if (this.newJob.err_file) {
        topScriptPart += `#SBATCH -e ${this.newJob.err_file} \n`
      }

      return topScriptPart + this.newJob.script_body
    },
    mailTypeSeparatedByComma: function () {
      if (this.newJob.mail.type) {
        const mailTypes = this.newJob.mail.type
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
      const givenTime = this.newJob.walltime
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
    // TODO: if machine.nodes and machine.name are not available, load the machine again.
  },
  methods: {
    onConfirmCreateJob: async function () {
      try {
        const sendingJob = {}
        sendingJob.nodes = this.newJob.nodes
        sendingJob.cores = this.newJob.cores
        sendingJob.mail_type = this.mailTypeSeparatedByComma
        sendingJob.mail_user = this.newJob.mail.user
        sendingJob.script = this.newJob.script_body
        sendingJob.project_id = this.newJob.project.id
        sendingJob.machine_id = this.$route.params.id
        sendingJob.slurm_cores = this.newJob.slurm_cores
        sendingJob.out_file = this.newJob.out_file
        sendingJob.err_file = this.newJob.err_file
        sendingJob.name = this.newJob.name

        await api.Job.create(sendingJob)
        this.$toast.add({
          severity: 'success',
          summary: 'Success Message',
          detail: `New Job ${sendingJob.name} created successfully.`,
          life: 3000,
        })
        this.$router.back()
      } catch (error) {
        this.$toast.add({
          severity: 'warn',
          summary: 'Warning Message',
          detail: `Coudldn't create new Job  ${error}`,
          life: 3000,
        })
      }
    },
  },
})
</script>
