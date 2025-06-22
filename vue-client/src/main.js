import './assets/main.css'
import './assets/tailwind.css'

import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

// Pinia
import { createPinia } from 'pinia'

// PrimeVue themes and components
import PrimeVue from 'primevue/config'
import Aura from '@primevue/themes/aura'
import ConfirmationService from 'primevue/confirmationservice'
import ToastService from 'primevue/toastservice'

// Importing Vue Code Block Package
import { VCodeBlock } from '@wdns/vue-code-block'

// Importing Vue3Markdown along with github markdown css
import Markdown from 'vue3-markdown-it';
import 'github-markdown-css/github-markdown.css';

// Fontawesome setup
import FontAwesomeIcon from './FontAwesomeSetup'

// Axios and Vue Axios
import axios from 'axios'
import VueAxios from 'vue-axios'

const app = createApp(App)

// adding font awesome icon as component
app.component('font-awesome-icon', FontAwesomeIcon)

// All Prime vue plugins
app.use(PrimeVue, {
  theme: {
    preset: Aura,
    options: {
      darkModeSelector: 'system', // Can be changed later with specific class for toggle option
    },
  },
})
app.use(ConfirmationService)
app.use(ToastService)

// Using VueCodeBlock
app.component('VCodeBlock', VCodeBlock)

// Using Vue3Markdown
app.use(Markdown)

// axios setup
axios.defaults.baseURL = 'http://localhost:3000'
app.use(VueAxios, axios)

// Pinia setup
const pinia = createPinia()
app.use(pinia)

app.use(router)
app.mount('#app')
