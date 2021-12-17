require "kemal"
require "./config"
require "./order"
require "./db"

module OrderForm
  error 404 do |env|
    # catch-all and serve the app
    env.response.headers["Content-Type"] = "text/html"
    File.open config.client_path / "index.html" do |file|
      IO.copy file, env.response
    end
  end

  post "/order" do |env|
    if body = env.request.body
      Order.create body, db: collection
    else
      halt env, status_code: 400, response: "No request body found"
    end
  end

  get "/products" do |env|
    config.products.to_json env.response
  end

  get "/thanks" do
    "Thanks!"
  end

  post "/error" do |env|
    if body = env.request.body
      body = case body
             in String then body
             in IO     then body.gets_to_end
             end
      errors.insert_one({request_body: body})
    else
      halt env, response: "no request body found"
    end
  end
  Kemal.run port: 21229
end
