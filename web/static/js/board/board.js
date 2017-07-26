import BootstrapVue from 'bootstrap-vue'
Vue.use(BootstrapVue);

import hBoard from './components/h-board.vue'
import hMtab from './components/h-mtab.vue'
import hSend from './components/h-send.vue'

import socket from '../socket'

const store = new Vuex.Store({
  state: {
    channel: socket.channel("board:lobby", {})
  },
  mutations: {
    join (state) {
      socket.connect()
      state.channel.join()
        .receive("error", resp => { console.log("Unable to join", resp) })
        .receive('ok', resp => {
          console.log("Joined successfully", resp)
          state.channel.push("new_msg", {
            name: document.querySelector('#nickname').textContent,
            body: '加入频道 ' + document.querySelector('#app .title').textContent,
            is_system: true
          })
        })
    },
    new_msg (state, payload) {
      state.channel.push("new_msg", payload)
    }
  }
})

export var Board = {run: function() {
  new Vue({
    el: '#app',
    store,
    components: { hBoard, hMtab, hSend },
    beforeCreate() {
      this.$store.commit('join')
    }
  });
}}