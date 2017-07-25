<template>
  <div class="row">
    <div class="col-sm-3">{{msg.name}} :</div>
    <div class="col-sm-9">{{msg.text}}</div>
  </div>
</template>

<style scoped>
</style>

<script>
  export default {
    props: ['msg'],
  };
</script>