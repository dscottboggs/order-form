<template>
  <div id="app">
    <OrderForm />
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import OrderForm from './components/OrderForm.vue'

export default Vue.extend({
  name: 'App',
  components: {
    OrderForm,
  },
})
</script>

<style lang="scss">
/** Add other SASS variables here if you want */

@import '~bulma';
@import '~buefy/src/scss/buefy';
</style>
