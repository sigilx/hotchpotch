<template>
  <b-tabs>
    <b-tab title="消息" active>
      <h-msg v-for="msg in msgs" :key="msg.text" :msg="msg"></h-msg>
    </b-tab>
    <b-tab title="人员">
      I'm the second tab content
    </b-tab>
    <b-tab title="房间">
      <b-card>I'm the card in tab</b-card>
    </b-tab>
  </b-tabs>
</template>

<style scoped>
</style>

<script>
  import hMsg from './h-msg.vue'

  export default {
    data() {
      return {
        msgs: [{text: "欢迎", name: "system"}],
      }
    },
    mounted() {
      this.$store.state.channel.on('new_msg', payload => {
        this.msgs.unshift({
          name: payload.name,
          text: payload.body,
          is_system: payload.is_system
        })
      })
    },
    components: {
      hMsg
    }
  };
</script>