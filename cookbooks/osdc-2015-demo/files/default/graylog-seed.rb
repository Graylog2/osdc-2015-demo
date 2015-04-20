#!/opt/chef/embedded/bin/ruby
#
# Script to prepare a Graylog server with some inputs and streams.

require 'json'
require 'uri'
require 'net/http'

$stdout.sync = true

class HTTPClient < Struct.new(:url)
  class Response < Struct.new(:response)
    def body
      response.body
    end

    def data
      JSON.parse(response.body)
    end

    def success?
      response.is_a?(Net::HTTPSuccess)
    end
  end

  def uri
    @uri ||= URI(url)
  end

  def request(req)
    Net::HTTP.start(uri.host, uri.port) {|http| http.request(req) }
  end

  def host_alive?
    !!Net::HTTP.get(uri)
  rescue
    false
  end

  def post(path, body = nil)
    req = Net::HTTP::Post.new(path)
    req.basic_auth(uri.user, uri.password)
    req['Content-Type'] = 'application/json'
    req.body = JSON.dump(body) if body

    Response.new(request(req))
  end

  def get(path)
    req = Net::HTTP::Get.new(path)
    req.basic_auth(uri.user, uri.password)

    Response.new(request(req))
  end
end

class GraylogServer < Struct.new(:client)
  def has_input?(title)
    response = client.get('/system/inputs')

    input = response.data['inputs'].find do |i|
      i['message_input']['title'][title]
    end

    !input.nil?
  end

  def has_stream?(title)
    !!get_stream(title)
  end

  def add_input(data)
    client.post('/system/inputs', data)
  end

  def add_stream(data)
    response = client.post('/streams', data)
    stream_id = response.data['stream_id']

    client.post("/streams/#{stream_id}/resume")
  end

  def add_stream_alert(title, data)
    stream_id = get_stream(title)['id']

    client.post("/streams/#{stream_id}/alerts/conditions", data)
  end

  def get_stream(title)
    response = client.get('/streams')

    response.data['streams'].find {|i| i['title'][title] }
  end

  def wait_until_alive(interval, additional_interval, limit = 600)
    waited = 0

    until client.host_alive?
      yield(waited) if block_given?
      sleep(interval)
      waited += interval

      if waited >= limit
        raise "Waited for #{limit}s - something seems to be wrong with the server."
      end
    end

    # Sleeping some extra seconds to wait until all inputs have been started...
    sleep(additional_interval) if waited > 0
  end
end


## MAIN

client = HTTPClient.new("http://admin:admin@127.0.0.1:12900/")
server = GraylogServer.new(client)
seed = JSON.parse(File.read('/etc/graylog/seed.json'))

# Wait until the Graylog server is reachable.
server.wait_until_alive(2, 6) do |seconds|
  puts "Waiting for server to startup. (elapsed: #{seconds}s)"
end

Array(seed['inputs']).each do |input|
  if server.has_input?(input['title'])
    puts "==> Input '#{input['title']}' exists"
  else
    server.add_input(input)
    puts "==> Added '#{input['title']}'"
  end
end

Array(seed['streams']).each do |stream|
  if server.has_stream?(stream['title'])
    puts "==> Stream '#{stream['title']}' exists"
  else
    server.add_stream(stream)
    puts "==> Added stream '#{stream['title']}'"
  end
end
