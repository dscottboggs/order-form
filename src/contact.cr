require "bson"
require "json"

module OrderForm
  record(Contact,
    email : String?,
    twitter : String?,
    matrix_handle : String?,
    phone_number : String?
  ) {
    include BSON::Serializable
    include JSON::Serializable
  }
end
