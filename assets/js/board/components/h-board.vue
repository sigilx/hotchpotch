<template>
  <div class="d-flex justify-content-center">
    <canvas id="canvas" class="whiteboard" width="800" height="500"
      @mousedown="start"
      @mousemove="move"
      @mouseup="drawing = false">
    </canvas>
  </div>
</template>

<style scoped>
.whiteboard {
  border: 1px solid #ddd;
  width: 100%;
  height: auto;
  background-color:whitesmoke;
}
</style>

<script>
  export default {
    data() {
      return {
        currX: null,
        currY: null,
        prevX: null,
        prevY: null,
        drawing: false,
        canvas: null,
        ctx: null,
        color: "#F63E02"
      }
    },
    mounted: function() {
      this.canvas = document.getElementById('canvas');
      this.ctx = canvas.getContext('2d');
      this.ctx.strokeStyle = this.color;
    },
    methods: {
      start: function() {
        this.drawing = true;
        this.ctx.moveTo(this.currX, this.currY);
      },
      move: function(event) {
        this.prevX = this.currX;
        this.prevY = this.currY;

        this.currX = event.clientX;
        this.currY = event.clientY;

        if (this.drawing) {
          this.ctx.lineTo(this.currX, this.currY);
          this.ctx.stroke();
        }
      }
    }
  };
</script>