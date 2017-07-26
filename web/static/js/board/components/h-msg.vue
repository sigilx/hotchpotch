<template>
  <div class="row">
    <div class="col-sm-3 px-0"><small>{{msg.name}} :</small></div>
    <div class="col-sm-9 px-0"><small>{{msg.text}}</small></div>
  </div>
</template>

<style scoped>
</style>

<script>
  export default {
    props: ['msg'],
  };
</script>