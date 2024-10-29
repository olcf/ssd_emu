/** @type {import('tailwindcss').Config} */
export default {
  // content field is for tailwindcss to point to directories to scan
  content: ['./index.html', './src/*.{js,ts,vue}', './src/**/*.{js,ts,vue}'],
  theme: {
    extend: {},
  },
  plugins: [],
}
