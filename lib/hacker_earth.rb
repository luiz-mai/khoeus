require 'net/http'

class HackerEarth

  @@ENDPOINT_COMPILE  =  "https://api.hackerearth.com/v3/code/compile/"
  @@ENDPOINT_RUN  =  "https://api.hackerearth.com/v3/code/run/"

  attr_accessor :source
  attr_accessor :lang
  attr_accessor :input

  def initialize(secret, source, lang, input = nil, tlimit = 5, mlimit = 262144, async = 0)
    @client_secret 	=  secret
    @source		=  source
    @lang		=  lang
    @input		=  input
    @tlimit		=  tlimit <= 5 ? tlimit : 5
    @mlimit		=  mlimit <= 262144 ? mlimit : 262144
    @async		=  async
  end

  def init_param
    @params = {
        :client_secret 	=>  @client_secret,
        :source 	=>  @source,
        :lang 		=>  @lang,
        :async 		=>  @async,
        :time_limit 	=>  @tlimit,
        :memory_limit 	=>  @mlimit
    }
    if @input
      @params.store(:input,@input)
    end
  end

  def compile
    init_param
    uri = URI(@@ENDPOINT_COMPILE)
    begin
      res = Net::HTTP.post_form(uri,@params)
      return res.body
    rescue
      abort "Error with the connection. Check your connectivity and try again.\n"
    end
  end

  def run
    init_param
    uri = URI(@@ENDPOINT_RUN)
    begin
      res = Net::HTTP.post_form(uri,@params)
      return res.body
    rescue
      abort "Error with the connection. Check your connectivity and try again.\n"
    end
  end

end