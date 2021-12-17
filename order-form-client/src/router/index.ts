import Vue from 'vue'
import VueRouter, { RouteConfig } from 'vue-router'
import OrderForm from "@/views/OrderForm.vue";
import Thanks from "@/views/Thanks.vue";

Vue.use(VueRouter)

const routes: Array<RouteConfig> = [
  {
    path: '/',
    name: 'OrderForm',
    component: OrderForm,
  },
  {
    path: '/thanks',
    name: 'Thanks',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    // component: () =>
    //   import(/* webpackChunkName: "thanks" */ '../views/Thanks.vue'),
    component: Thanks
  },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes,
})

export default router
