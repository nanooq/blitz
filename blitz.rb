#!/usr/bin/env ruby

# This is hacked together.
# Please PM me for the Websocket URL

URL = ""  

require 'faye/websocket'
require 'eventmachine'

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
  ws = Faye::WebSocket::Client.new(URL)

  ws.on :open do |event|
    puts "Starting to generate random numbers from lighting strokes."
  end

  ws.on :message do |event|
    # p [:message, event.data]
    gen_rand(Time.now.to_i)
  end

  ws.on :close do |event|
    # p [:close, event.code, event.reason]
    ws = nil
  end
}
