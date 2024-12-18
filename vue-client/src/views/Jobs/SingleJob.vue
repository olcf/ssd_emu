<template>
  <div class="p-4">
    <Card>
      <template #title>{{ loadedJob.name }}</template>
      <template #subtitle>Job Details</template>
      <template #content>
        <div class="job-property">
          <span class="property-key">Nodes:</span>
          <span class="property-value">{{ loadedJob.nodes }}</span>
        </div>
        <div class="job-property">
          <span class="property-key">Cores:</span>
          <span class="property-value">{{ loadedJob.cores || 'NA' }}</span>
        </div>
        <div class="job-property">
          <span class="property-key">Mail Type:</span>
          <span class="property-value">{{ loadedJob.mail_type || 'NA' }}</span>
        </div>
        <div class="job-property">
          <span class="property-key">Mail User:</span>
          <span class="property-value">{{ loadedJob.mail_user || 'NA' }}</span>
        </div>
        <div class="job-property">
          <span class="property-key">Script:</span>
          <span class="property-value">
            <StyledOutput :job="loadedJob"></StyledOutput>
          </span>
        </div>
        <div class="job-property">
          <span class="property-key">Project ID:</span>
          <span class="property-value">{{ loadedJob.project_id || 'NA' }}</span>
        </div>
        <div class="job-property">
          <span class="property-key">Slurm Cores:</span>
          <span class="property-value">{{ loadedJob.slurm_cores || '8' }}</span>
        </div>
        <div class="job-property">
          <span class="property-key">Output File:</span>
          <span class="property-value">{{
            loadedJob.out_file || 'STDOUT'
          }}</span>
        </div>
        <div class="job-property">
          <span class="property-key">Walltime:</span>
          <span class="property-value">{{ loadedJob.walltime }} seconds</span>
        </div>
        <div class="job-property">
          <span class="property-key">Error File:</span>
          <span class="property-value">{{
            loadedJob.err_file || 'STDERR'
          }}</span>
        </div>
      </template>
    </Card>
  </div>
</template>

<script>
import { api } from '@/apis'
import StyledScript from '@/components/Jobs/StyledScript.vue'
import StyledOutput from '@/components/Jobs/StyledOutput.vue'

export default {
  components: {
    StyledScript,
    StyledOutput,
  },
  data() {
    return {
      loadedJob: {
        name: 'Loading Job',
        nodes: 0,
        cores: 0,
        mail_type: 'loading...',
        mail_user: 'loading...',
        script: 'loading...',
        project_id: 'loading...',
        machine_id: 'loading...',
        slurm_cores: 8,
        out_file: 'loading...',
        walltime: 'loading...',
        err_file: 'loading...',
      },
    }
  },
  watch: {
    // eslint-disable-next-line no-unused-vars
    async '$route.params.jobId'(to, from) {
      await this.loadJob()
    },
  },
  async created() {
    await this.loadJob()
  },
  methods: {
    loadJob: async function () {
      const toLoadJob = await api.Job.getById(this.$route.params.jobId)
      this.loadedJob = toLoadJob
    },
  },
}
</script>

<style scoped>
.job-property {
  border-bottom: 1px solid #ddd;
  padding: 0.6rem;
}

.property-key {
  font-weight: bold;
  color: #7d8591;
  padding-right: 1rem;
}

.property-value {
  color: white;
  font-size: 0.95rem;
}
</style>
