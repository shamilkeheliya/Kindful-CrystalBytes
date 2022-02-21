import { createApp } from 'vue'
import App from './App.vue'
import router from "./router";

import firebase from "firebase";
require('firebase/firestore');

/*createApp(App).mount('#app')*/


// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBwi8pKLqKXhIq3lzJEvL3uT57hu7mJI8Y",
  authDomain: "kindful-6b6dd.firebaseapp.com",
  projectId: "kindful-6b6dd",
  storageBucket: "kindful-6b6dd.appspot.com",
  messagingSenderId: "14056090943",
  appId: "1:14056090943:web:65b1b5d214c19bd25e778a",
  measurementId: "G-VKRBRVG84Y"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);

Vue.config.productionTip = false;

new Vue({
  router,
  render: h => h(App)
}).$mount("#app");