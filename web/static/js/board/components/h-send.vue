<template>
  <b-input-group left="聊天">
    <b-form-input v-model="text" type="text" @keyup.enter="sendMsg"></b-form-input>
    <b-input-group-button slot="right">
      <b-button variant="success" @click="sendMsg"> 发送 </b-button>
    </b-input-group-button>
  </b-input-group>
</template>

<style scoped>
</style>

<script>
import socket from '../../socket'
const channel = socket.channel("board:lobby", {})

export default {
  data() {
    return {msg: [], text: ''}
  },
  mounted() {
    socket.connect()
    this.joinChannel()
    console.log(this.$store.state.count)
  },
  methods: {
    sendMsg() {
      this.$store.commit('increment')
      channel.push('new_msg', {
        body: this.text,
        isSystem: false
      })
      this.text = ''
    console.log(this.$store.state.count)
    },
    joinChannel() {
      channel.join()
        .receive("error", resp => { console.log("Unable to join", resp) })
        .receive('ok', resp => {
          console.log("Joined successfully", resp)
          channel.push('new_msg', {
            body: 'joined #random',
            isSystem: true
          })
        })
    }
  },
};
</script>