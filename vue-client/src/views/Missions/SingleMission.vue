<template>
  <div>
    <div class="text-center text-3xl">
      {{ mission.title || 'Unavailable Mission' }}
    </div>
    <div class="flex flex-col gap-4">
      <div class="text-xl">{{ mission.content }}</div>
      <ul class="grid gap-6 sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
        <li
          v-for="chapter in mission.chapters"
          :key="chapter.id"
          class="bg-gray-800 rounded-2xl p-5 shadow-md hover:shadow-lg transition duration-300"
        >
          <router-link
            :to="`/mission/${$route.params.id}/chapter/${chapter.id}`"
            class="block space-y-3"
          >
            <div class="flex items-center justify-between">
              <div
                class="flex items-center gap-2 text-white text-lg font-semibold"
              >
                <i class="pi pi-book text-blue-400"></i>
                {{ chapter.title }}
              </div>
              <i
                :class="[
                  'text-xl',
                  chapter.is_completed
                    ? 'pi pi-check-circle text-green-400'
                    : 'pi pi-circle text-gray-500',
                ]"
                :title="chapter.is_completed ? 'Completed' : 'Incomplete'"
              ></i>
            </div>
            <p class="text-sm text-gray-300 leading-relaxed">
              {{ chapter.short_description }}
            </p>
          </router-link>
        </li>
      </ul>
    </div>
  </div>
</template>
<script>
import { defineComponent } from 'vue'
import { api } from '@/apis'
export default defineComponent({
  name: 'SingleMission',
  data() {
    return {
      mission: {},
    }
  },
  created: async function () {
    await this.updateNecessaryData()
  },
  // here we are watching route id so that we can update the UI accordingly
  watch: {
    // eslint-disable-next-line no-unused-vars
    async '$route.params.id'(to, from) {
      await this.updateNecessaryData()
    },
  },
  methods: {
    async updateNecessaryData() {
      const currentMission = await api.Mission.getMissionWithChapters(
        this.$route.params.id,
      )
      this.mission = currentMission
    },
  },
})
</script>
