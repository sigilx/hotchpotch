import BootstrapVue from 'bootstrap-vue'
Vue.use(BootstrapVue);

import hBoard from './components/h-board.vue'
import hMtab from './components/h-mtab.vue'
import hSend from './components/h-send.vue'

export var Board = {run: function() {
  new Vue({
    el: '#app',
    components: { hBoard, hMtab, hSend }
  });
}}