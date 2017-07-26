import BootstrapVue from 'bootstrap-vue'
Vue.use(BootstrapVue);

import hBoard from './components/h-board.vue'
import hMtab from './components/h-mtab.vue'
import hSend from './components/h-send.vue'

const store = new Vuex.Store({
  state: {
    count: 0
  },
  mutations: {
    increment (state) {
      state.count++
    }
  }
})

export var Board = {run: function() {
  new Vue({
    el: '#app',
    store,
    components: { hBoard, hMtab, hSend }
  });
}}