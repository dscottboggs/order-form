<template>
  <div>
    <div class="columns">
      <div class="column is-2" />
      <div class="column is-8">
        <section class="section">
          <h1 class="title">Get some plants here</h1>
          <h2 class="subtitle">Plants</h2>
          <b-field
            v-for="product in products"
            :key="product.name"
            :label="product.description"
            horizontal
          >
            <b-numberinput
              v-model="product.quantity"
              min="0"
              max="5"
              controls-position="compact"
            />
          </b-field>

          <div v-if="!products.length">
            <b-message>Loading list of plants</b-message>
            <b-progress />
          </div>

          <b-field
            horizontal
            label="How many plants do you need soil for?"
            v-if="products.length"
          >
            <b-numberinput
              v-model="soil"
              controls-position="compact"
              min="0"
              :max="totalPlantsInOrder"
            />
          </b-field>

          <hr />

          <h3 class="subtitle">Contact info</h3>

          <b-message>
            You don't need to give us any contact info, but if you want us to
            let you know when we ship your plant (or be able to let you know if
            something goes wrong and we can't), fill in one of these
          </b-message>
          <br />
          <div class="columns">
            <div class="column is-1"></div>
            <div class="column is-7">
              <b-field label="Email" label-position="on-border">
                <b-input v-model="email" />
              </b-field>
              <b-field label="Twitter" label-position="on-border">
                <b-input v-model="twitter" />
              </b-field>
              <b-field label="Matrix handle" label-position="on-border">
                <b-input v-model="matrix" />
              </b-field>
              <b-field label="Phone Number" label-position="on-border">
                <b-input v-model="phone" />
                <b-select v-model="callOrSMS" label="Prefer">
                  <option value="call">Call</option>
                  <option value="sms">SMS</option>
                </b-select>
              </b-field>
              <hr />
              <b-field label="Shipping Address" label-position="on-border">
                <b-input
                  type="textarea"
                  v-model="address"
                  placeholder="We need to know where to send it!"
                />
              </b-field>
              <br />
              <b-field label="Extra note" label-position="on-border">
                <b-input
                  type="textarea"
                  v-model="note"
                  placeholder="Special instructions or other note tied to your request"
                />
              </b-field>
            </div>
            <div class="column"></div>
          </div>

          <hr />
          <button class="button" @mouseup="submit">Submit Request</button>
        </section>
      </div>
      <div class="column"></div>
    </div>
    <footer class="footer">Put some footer content here</footer>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'

class Product {
  name: string
  description: string
  image?: string
  quantity: number

  constructor(name: string, description: string, image?: string) {
    this.name = name
    this.description = description
    this.image = image
    this.quantity = 0
  }
  static fromServer({ name, description, image }: any): Product {
    return new Product(name, description, image)
  }
}

export default Vue.extend({
  data() {
    return {
      products: new Array<Product>(),
      address: '',
      twitter: '',
      email: '',
      matrix: '',
      phone: '',
      soil: 0,
      callOrSMS: 'call',
      note: '',
    }
  },
  created() {
    fetch(`/products`)
      .then(resp => {
        if (resp.ok) {
          return resp.json()
        } else {
          console.debug('response body')
          console.debug(resp.body)
          return Promise.reject(`failed to fetch products: ${resp.statusText}`)
        }
      })
      .then(products => {
        this.products = Array.prototype.map.call(
          products,
          Product.fromServer
        ) as Array<Product>
      })
      .catch(error => {
        console.error(error)
        alert(error.message || error)
      })
  },
  computed: {
    totalPlantsInOrder() {
      return this.$data.products.reduce(
        (acc: number, product: Product) => acc + product.quantity,
        0
      )
    },
  },
  methods: {
    requestBody() {
      return {
        contact_info: {
          email: this.email,
          twitter: this.twitter,
          matrix_handle: this.matrix,
          phone_number: this.phone,
        },
        address: this.address,
        note: this.note,
        order: this.products.reduce(
          (order: Array<string>, product: Product) => {
            if (product.quantity) order.push(product.name)
            return order
          },
          []
        ),
        soil: this.soil,
        sms: this.callOrSMS == 'sms',
      }
    },
    async submit() {
      if (!this.address) {
        alert('we need an address to know where to send it!')
        return
      }
      if (!this.totalPlantsInOrder) {
        alert('why submit an order for no plants?')
        return
      }
      try {
        let response = await fetch('/order', {
          body: JSON.stringify(this.requestBody()),
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
        })
        if (response.ok) {
          confirm('successfully submitted')
          window.location.pathname = '/thanks'
        } else {
          throw `error submitting response: ${response.statusText}`
        }
      } catch (err) {
        console.error(err)
        // nothing we can do if this fails
        fetch('/error', {
          method: 'POST',
          body: JSON.stringify(err),
        })
        alert(err)
      }
    },
  },
})
</script>
