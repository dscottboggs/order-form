# Order form

My partner had some plant cuttings after trimming the houseplants, and wanted to give away the clones, but didn't want to do it through Google forms. I told him I'd whip this up for him. [Have us send you some plants!](https://free-plants.tams.tech)

The ideas fleshed out in this project are being reformulated into a more general-purpose "free-store" [here](https://github.com/dscottboggs/free-store).

## Deploying

<h3 style="color: red">PLEASE DO NOT deploy this without a firewall!</h3>
The way mongo is configured by `make install` leaves it totally without authentication, so if you were to deploy this on a VPS, for example, with no firewall rules, **ANYONE** can just `mongosh --host your-vps-ip` and have full read-write-delete access to the database!

I know best practice is multi-layer security but this was a pretty low-effort project and it's not the end of the world if someone were to somehow get through.

```
$ git clone git@github.com:dscottboggs/order-form.git
$ cd order-form
$ make install
$ curl localhost:21229/products
```

Now, that gets you the exact site found at https://free-plants.tams.tech, but if you're not me then you probably want to change some things. The "notes about the plants" to the right are in [ `order-form-client/src/views/OrderFrom.vue` ](https://github.com/dscottboggs/order-form/blob/master/order-form-client/src/views/OrderForm.vue), they can be erased. Rewrite the config file with your list of stuff you want to give away and there ya go! Of course, then you need to configure a reverse proxy, certificates, DNS...isn't the internet fun?

I had considered setting up a Telegram or Matrix bot to notify me when there's a request, but I don't want to direct my effort in that direction right now, so I've just been checking the database once a day with:

```
$ mongosh --host order-form-mongo.local
test> use mongo
switched to db mongo
mongo> db.plants.find()

mongo> db.errors.find()

```

## Contributing

1. Fork it (<https://github.com/dscottboggs/order-form/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [D. Scott Boggs](https://github.com/dscottboggs) - creator and maintainer
