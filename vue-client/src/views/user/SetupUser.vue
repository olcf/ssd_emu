<template>
  <Dialog
    :visible="view_setup_dialog"
    modal
    header="Setup your User"
    :style="{ width: '80rem', 'min-height':'60vh' }"
  >
    <div class="flex align-center justify-center text-4xl underline py-6">
      Setup your User
    </div>
    <div v-if="userInfo.username =='default_username'" class="text-red-400">
      You need to change your username to access the system!
    </div>
    <Form @submit.prevent="onEditUser" class="flex flex-col mt-10">
      <div class="flex flex-wrap gap-12">
        <!-- Username -->
        <div class="flex flex-col gap-2">
          <label for="username">Username</label>
          <InputText id="username" v-model="userInfo.username"></InputText>
        </div>
        <!-- First Name -->
        <div class="flex flex-col gap-2">
          <label for="first_name">First Name</label>
          <InputText id="first_name" v-model="userInfo.first_name"></InputText>
        </div>
        <!-- Last Name -->
        <div class="flex flex-col gap-2">
          <label for="last_name">Last Name</label>
          <InputText id="last_name" v-model="userInfo.last_name"></InputText>
        </div>
        <!-- Email -->
        <div class="flex flex-col gap-2">
          <label for="email">Email</label>
          <InputText id="email" v-model="userInfo.email"></InputText>
        </div>
      </div>

      <div class="p-3 text-right">
        <Button
          label="Cancel"
          text
          severity="secondary"
          icon="pi pi-times"
          @click="this.$router.back()"
        ></Button>
        <Button type="submit" label="Save your info" icon="pi pi-save"></Button>
      </div>
    </Form>
  </Dialog>
</template>
<script>
import { api } from '@/apis'
import { defineComponent } from 'vue'
import { useUserStore } from '@/stores/user'

export default defineComponent({
  name: 'SetupUser',
  data() {
    return {
      view_setup_dialog:true,
      machines: [],
      userInfo: {
        username: '',
        user_id: '',
        first_name: '',
        last_name: '',
        email: '',
      },
    }
  },
  async mounted() {
    await this.loadUser()
  },
  methods: {
    async loadUser() {
      const userStore = useUserStore()
      const u = userStore.getUserInfo
      // If we use plain userInfo object, it will put reactive userInfo state, causing it to infinite recursion.

      this.userInfo = {
        user_id: u.user_id,
        username: u.username,
        first_name: u.first_name,
        last_name: u.last_name,
        email: u.email,
      }
    },
    async onEditUser() {
      try {
        let sendingUserInfo = {}
        sendingUserInfo = this.userInfo
        await api.User.updateUser(sendingUserInfo)
        this.$toast.add({
          severity: 'success',
          summary: 'Success Message',
          detail: `Your user updated successfully.`,
          life: 3000,
        })
        this.$router.replace('/').then(() => {
          window.location.reload()
        })
      } catch (error) {
        console.log(error)
        this.$toast.add({
          severity: 'warn',
          summary: 'Warning Message',
          detail: `Couldn't update your user ${error}`,
          life: 3000,
        })
      }
    },
  },
})
</script>
