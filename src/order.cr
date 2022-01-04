require "json"
require "bson"
require "./contact"
require "./product"
require "./db"

module OrderForm
  record(
    Order,
    contact_info : Contact,
    order : Array(Product::Order),
    sms : Bool,
    address : String,
    soil : Int32,
    note : String
  ) do
    record Serialized,
      contact_info : Contact,
      order : Hash(String, Int32),
      sms : Bool,
      address : String,
      soil : Int32,
      note : String do
      include BSON::Serializable
      include JSON::Serializable
    end
    include BSON::Serializable
    include JSON::Serializable

    def self.create(body, db collection)
      order = Serialized.from_json body
      products = order.order.compact_map do |id, quantity|
        if product = OrderForm.config.products.find &.id.== id
          product.for_order quantity
        else
          OrderForm.errors.insert_one({
            message:      "failed to find product",
            product_name: name,
          })
          STDERR.puts "warning: visitor requested product which is not in the configuration: '#{name}'"
          nil
        end
      end
      entry = new order.contact_info, products, order.sms, order.address, order.soil, order.note
      collection.insert_one entry
    end
  end
end
