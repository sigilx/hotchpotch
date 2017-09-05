<template>
  <div class="d-flex justify-content-center">
    <canvas class="whiteboard"></canvas>
    <div class="colors">
      <div class="color black"></div>
      <div class="color red"></div>
      <div class="color green"></div>
      <div class="color blue"></div>
      <div class="color yellow"></div>
    </div>
  </div>
</template>

<style scoped>
.whiteboard {
  border: 1px solid #ddd;
  width: 100%;
  height: 100%;
  background-color:whitesmoke;
}
.colors {
  position: absolute;
}
.color {
  display: inline-block;
  height: 42px;
  width: 42px;
}
.color.black { background-color: black; }
.color.red { background-color: red; }
.color.green { background-color: green; }
.color.blue { background-color: blue; }
.color.yellow { background-color: yellow; }
</style>

<script>
  export default {};
</script>