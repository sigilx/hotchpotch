import BootstrapVue from 'bootstrap-vue'
import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)
Vue.use(BootstrapVue);

import hBoard from './components/h-board.vue'
import hMtab from './components/h-mtab.vue'
import hSend from './components/h-send.vue'

import socket from '../socket'

const store = new Vuex.Store({
  state: {
    chatChan: socket.channel("board:chat:" + window.location.pathname.split('/').pop(), {}),
    drawChan: socket.channel("board:draw:" + window.location.pathname.split('/').pop(), {})
  },
  mutations: {
    join (state) {
      socket.connect();
      state.chatChan.join()
        .receive("error", resp => { console.log("Unable to join: ", resp.reason) })
        .receive('ok', resp => {
          console.log("Joined chat channel successfully", resp);
          state.chatChan.push("new_msg", {
            name: document.querySelector('#nickname').textContent,
            body: '加入频道 ' + document.querySelector('#app .title').textContent,
            is_system: true
          })
        });
      state.drawChan.join()
        .receive("error", resp => { console.log("Unable to join: ", resp.reason) })
        .receive('ok', resp => {
          console.log("Joined draw channel successfully", resp);
        });
    },
    new_msg (state, payload) {
      state.chatChan.push("new_msg", payload)
    },
    drawing (state, payload) {
      state.drawChan.push("drawing", payload)
    }
  }
})

new Vue({
  el: '#app',
  store,
  components: { hBoard, hMtab, hSend },
  beforeCreate() {
    this.$store.commit('join')
  }
});
