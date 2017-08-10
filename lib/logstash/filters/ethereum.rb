# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# This  filter will replace the contents of the default 
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an .
class LogStash::Filters::Ethereum < LogStash::Filters::Base

  require 'logstash/filters/decoder/decoder'

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   ethereum {
  #     decode => { "fieldname" => "int" }
  #   }
  # }
  #
  config_name "ethereum"
  
  config :decode, :validate => :hash
  

  public
  def register
    @decoder = Decoder.new
  end # def register

  public
  def filter(event)

    decode(event) if @decode

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter

  def decode(event)
    @decode.each do |field, type|
      next unless event.include?(field)

      event.set(field, @decoder.decode(type, field))
    end
  end

end # class LogStash::Filters::Ethereum
