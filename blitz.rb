#!/usr/bin/env ruby

require 'json'
require 'faye/websocket'
require 'eventmachine'

maps = JSON.parse(File.read("maps.json"))
map = maps["maps"][ARGV.first.to_str]

EM.run {
  ws = Faye::WebSocket::Client.new("ws://websocketserver.blitzortung.org:801" + "#{(rand() * 10).to_i}")

  ws.on :open do |event|
    ws.send "{\"region\":#{map["region"]},\"west\":#{map["west"]},\"east\":#{map["east"]},\"north\":#{map["north"]},\"south\":#{map["south"]}}" 
  end

  ws.on :message do |event|
    p [:message, event.data]
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end
}
