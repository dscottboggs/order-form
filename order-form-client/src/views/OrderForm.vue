<template>
  <div style="margin-top: 5%">
    <div class="container">
      <div class="columns">
        <div class="column is-half">
          <h1 class="title">Get some plants here</h1>
          <h2 class="subtitle">Plants</h2>
          <div class="box" v-for="product in products" :key="product.id">
            <b-field :label="product.name || product.id">
              <b-numberinput
                v-model="product.quantity"
                min="0"
                :max="product.max || 5"
              />
            </b-field>
            <article v-if="product.description">
              {{ product.description }}
            </article>
          </div>

          <div v-if="!products.length">
            <b-message>Loading list of plants</b-message>
            <b-progress />
          </div>

          <b-field
            horizontal
            label="How many plants do you need soil for?"
            v-if="products.length && totalPlantsInOrder"
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

          <button
            class="button is-primary is-align-content-flex-end"
            @mouseup="submit"
          >
            Submit Request
          </button>
        </div>
        <div class="column is-1"></div>
        <div class="column is-5">
          <article class="message is-primary">
            <h2 class="subtitle message-header">Plant notes</h2>
            <div class="message-body">
              Our house has a powdery mildew issue and while i've been
              extra-careful about plant hygiene to mitigate it, there will
              probably be some spores on your plant. The best advice I have is
              to rinse the roots (or the whole plant, if you can) thoroughly in
              warm water before potting, to pot as soon as possible, and to
              maintain a moist potting medium with good drainage without
              overwatering the plant. That can be pretty tricky with desert
              plants, but the creeping charlie loves water, as long as it's got
              a place to drain excess. Use a pot with holes in the bottom and a
              plate or saucer underneath to catch water, and don't water again
              until that has dried. Also don't use too big a pot, as bare soil
              appears to be very attractive to this mildew. Disrupting the
              pathogen + supporting the plant will allow the plant to win the
              struggle for survival, and good hygiene &amp; watering habits will
              prevent it from being able to grow strong again. You can also
              contact me (give details) if you think an issue is developing. I
              can't guarantee or warranty these plants but I'm happy to try to
              help informally.
            </div>
          </article>
          <article class="message is-danger">
            <h2 class="subtitle message-header">
              Instructions for plant-care on arrival
            </h2>
            <div class="message-body">
              Rinse the plant off very well as soon as possible and inspect it
              as it air dries. Be careful with the fragile roots and buds. Using
              clean hands or scissors, remove any leaves and/or buds that have
              mostly or fully shriveled or dried en route. Some plants, such as
              creeping charlie or burro's tail, may respond immediately upon
              exposure to water by changing color, swelling, or even orienting
              toward the nearest light source. These are great signs. Negative
              signs include excessive sliminess, a bad rotting-vegetable odor,
              mushy or excessively-limp stems, and stems that have completely
              dried-out, as well as any visible mold. Take a picture if there's
              physical damage from travel or if you suspect an issue. If you
              have the time to pot it right away, stick it in some clean,
              room/skin temperature water (DO NOT use cold or hot water, it WILL
              shock the plant, test it with your hand first) and let it soak for
              10-30 minutes. You can get the pot ready while it does this. DON'T
              cut the stem like you would with flowers; you can trim the stems
              down if necessary, but leave as many roots and leaves intact as
              you can. Dump in the soil and fluff it up, then either mist it,
              place the pot in a saucer with water or drip a few drops on the
              top. The soil needs to be moist without being compacted. Once your
              plant looks like it's perked up from its drink, rinse the stem and
              roots off again and stick it in the soil. You can use your fingers
              to poke a hole for it, just don't compact the soil around it if
              possible (you can put rocks or moss or whatever decorations on top
              as long as they don't weigh it down a lot). When the soil on top
              is dry to the touch, give it another mist/drop/refresh the saucer
              water, and your new plant should settle in. All of these plants
              prefer bright, indirect sunlight, but can tolerate more or less,
              somewhat. Experiment! Kost of these plants (except the burro's
              tail) do best in a warm and humid environment, which you can't
              really recreate in a house without a big investment, so these
              watering techniques help make up for it. You can and probably
              should mist your plant a little if it looks thirsty, just hold off
              on watering for a day to avoid overdoing it.
            </div>
          </article>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'

class Product {
  id: string
  name: string
  description: string
  image?: string
  quantity: number
  max: number

  constructor(
    id: string,
    name: string,
    description: string,
    image?: string,
    max = 5
  ) {
    this.id = id
    this.name = name
    this.description = description
    this.image = image
    this.quantity = 0
    this.max = max
  }
  static fromServer({ id, name, description, image, max }: any): Product {
    return new Product(id, name, description, image, max)
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
          (order: { [key: string]: number }, product: Product) => {
            if (product.quantity) order[product.id] = product.quantity
            return order
          },
          {}
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
