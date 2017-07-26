<template>
  <div class="row">
    <div class="col-sm-3 px-0">{{msg.name}} :</div>
    <div class="col-sm-9 px-0">{{msg.text}}</div>
  </div>
</template>

<style scoped>
</style>

<script>
  export default {
    props: ['msg'],
  };
</script>