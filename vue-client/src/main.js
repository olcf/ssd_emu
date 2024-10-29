import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import PrimeVue from 'primevue/config'
import Aura from '@primevue/themes/aura'

// Fontawesome setup
import FontAwesomeIcon from './FontAwesomeSetup'

const app = createApp(App)

// adding font awesome icon as component
app.component('font-awesome-icon', FontAwesomeIcon)

app.use(router)

app.use(PrimeVue, {
  theme: {
    preset: Aura,
    options: {
      darkModeSelector: 'system', // Can be changed later with specific class for toggle option
    },
  },
})

app.mount('#app')
