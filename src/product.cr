require "yaml"
require "bson"
require "json"

module OrderForm
  record Product, name : String, description : String, image : String? do
    include BSON::Serializable
    include YAML::Serializable
    include JSON::Serializable

    record(
      Order,
      name : String,
      description : String,
      image : String?
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
        @name, @description = bson["name"], bson["description"]
        @image = bson["image"]?
        @status = bson["status"].try(&->Status.parse(String)) || :created
      end

      def to_bson(bson = BSON.new)
        {% for ivar in %w[name description image] %}
          bson[{{ivar}}] = @{{ivar.id}}
        {% end %}
        bson["status"] = @status.to_s
        bson
      end
    end

    def for_order
      Product::Order.new name, description, image
    end
  end
end
