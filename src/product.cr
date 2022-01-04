require "yaml"
require "bson"
require "json"

module OrderForm
  record Product, id : String?, name : String, description : String, image : String?, max : Int32? do
    include BSON::Serializable
    include YAML::Serializable
    include JSON::Serializable

    record(
      Order,
      id : String?,
      name : String,
      image : String?,
      quantity : Int32
    ) do
      enum Status
        Created
        Accepted
        Shipped
        Received
      end
      include BSON::Serializable
      include JSON::Serializable
      property status : Status = :created

      def initialize(bson : BSON)
        @id, @name, @quantity = bson["id"], bson["name"], bson["quantity"]
        @image = bson["image"]?
        @status = bson["status"].try(&->Status.parse(String)) || :created
      end

      def to_bson(bson = BSON.new)
        {% for ivar in %w[id name quantity image] %}
          bson[{{ivar}}] = @{{ivar.id}}
        {% end %}
        bson["status"] = @status.to_s
        bson
      end
    end

    def for_order(quantity)
      Product::Order.new id, name, image, quantity
    end
  end
end
