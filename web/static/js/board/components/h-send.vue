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
export default {
  data() {
    return {msg: [], text: ''}
  },
  methods: {
    sendMsg() {
      let payload = {
        name: document.querySelector('#nickname').textContent,
        body: this.text,
        is_system: false
      }
      this.$store.commit("new_msg", payload)
      this.text = ''
    }
  },
};
</script>