require "cryomongo"
require "./config"

module OrderForm
  class_property mongo : Mongo::Client do
    Mongo::Client.new "mongodb://#{config.database.host}:#{config.database.port}/"
  end

  class_property(database : Mongo::Database) { mongo[config.database.database] }

  class_property(collection : Mongo::Collection) { database[config.database.collection] }
  class_property(errors : Mongo::Collection) { database["client_errors"] }
end
