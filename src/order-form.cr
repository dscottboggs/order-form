require "http/server"
require "magic"
require "./config"
require "./order"
require "./db"

# Halt execution with the current context.
# Returns 200 and an empty response by default.
#
# ```
# halt env, status_code: 403, response: "Forbidden"
# ```
# Copied from Kemal
macro halt(env, status_code = 200, response = "")
  {{env}}.response.status_code = {{status_code}}
  {{env}}.response.print {{response}}
  {{env}}.response.close
  next
end

module OrderForm
  MIME = Magic.mime_type

  def self.run
    server = HTTP::Server.new do |context|
      case {context.request.method, context.request.path}
      when {"POST", "/order"}
        if body = context.request.body
          Order.create body, db: collection
        else
          halt context, status_code: 400, response: "No request body found"
        end
      when {"GET", "/products"}
        config.products.to_json context.response
      when {"POST", "/error"}
        if body = context.request.body
          body = case body
                 in String then body
                 in IO     then body.gets_to_end
                 end
          errors.insert_one({request_body: body})
        else
          halt context, response: "no request body found"
        end
      else
        filepath = config.client_path / if context.request.path == "/"
          "index.html"
        else
          context.request.path
        end
        filepath = config.client_path / "index.html" unless File.exists? filepath
        context.request.headers["Content-Type"] = MIME.of filepath.to_s
        File.open filepath do |file|
          IO.copy file, context.response
        end
      end
    end
    address = server.bind_tcp 21229
    puts "listening on #{address}"
    server.listen
  end
end

OrderForm.run
