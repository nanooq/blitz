#!/usr/bin/env ruby

require 'json'
require 'faye/websocket'
require 'eventmachine'

maps = JSON.parse(File.read("maps.json"))
map = maps["maps"][ARGV.first.to_str]

@i = 0
@time = Array.new(4)

def gen_rand(click)
  if @i < 4
    @time[@i] = click
    @i += 1
  elsif @i == 4
    length1 = @time[1] - @time[0]
    length2 = @time[3] - @time[2]
    if length2 > length1
      puts "1"
    elsif length2 < length1
      puts "0"
    else; end
    @i = 0 
  end
end

EM.run {
  ws = Faye::WebSocket::Client.new("ws://websocketserver.blitzortung.org:801" + "#{(rand() * 10).to_i}")

  ws.on :open do |event|
    puts "Starting to generate random numbers from lighting strokes."
    ws.send "{\"region\":#{map["region"]},\"west\":#{map["west"]},\"east\":#{map["east"]},\"north\":#{map["north"]},\"south\":#{map["south"]}}" 
  end

  ws.on :message do |event|
    gen_rand(Time.now.to_i)
  end

  ws.on :close do |event|
    ws = nil
  end
}
