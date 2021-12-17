require "yaml"

require "xdg"

require "./product"

module OrderForm
  class Config
    include YAML::Serializable

    property database : DBConfig

    @[YAML::Field(key: "site title")]
    property site_title : String

    class DBConfig
      include YAML::Serializable

      property host : String = "localhost",
        port : UInt16 = 27017_u16,
        database : String = "mongo",
        collection : String = ENV.fetch "collection", "plants"
    end

    property products : Array(Product)
    # Path to the rendered client
    property client : String = "order-form-client/dist"

    def client_path : Path
      Path.new client
    end
  end

  class_property config_file_location : Path? = ENV["config_file"]?.try(&->Path.new(String)) || XDG.config_file "order_form.yml"

  class_property config : Config do
    if floc = config_file_location
      File.open floc do |file|
        Config.from_yaml file
      end
    else
      Config.from_yaml STDIN
    end
  end
end
