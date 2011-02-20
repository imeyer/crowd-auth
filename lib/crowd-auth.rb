require 'rest-client'

module Crowd
  # This is some kind of comment
  class Auth
    attr_accessor :crowd_url, :crowd_app_name, :crowd_app_pass, :crowd_auth_uri
    
    def initialize(options = {})
      options.each { |key, value| instance_variable_set("@#{key}", value) }
      @crowd_auth_uri ||= "/crowd/rest/usermanagement/latest/authentication"
    end
    
    def authenticate(username, password)
      rest_client = RestClient::Resource.new "#{@crowd_url}?username=#{username}", :user => @crowd_app_name, :password => @crowd_app_pass
      
      resp = rest_client[@crowd_auth_uri].post "{\"value\":\"#{password}\"}", :accept => "application/json", :content_type => "application/json"
      
      return resp
    end
  end
end