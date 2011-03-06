require 'rest-client'
require 'json'

module Crowd
  class Auth
    attr_accessor :crowd_url, :crowd_app_name, :crowd_app_pass, :crowd_auth_uri

    def initialize(options = {})
      options.each { |key, value| instance_variable_set("@#{key}", value) }
      @crowd_auth_uri ||= "/crowd/rest/usermanagement/1"
    end

    def new_session(username, password)
      rest_client = RestClient::Resource.new @crowd_url, :user => @crowd_app_name, :password => @crowd_app_pass

      begin
        resp = rest_client["#{@crowd_auth_uri}/session.json"].post json_session(username, password), :content_type => "application/xml"
      rescue RestClient::BadRequest
        return false
      end
      
      if resp.code == 201
        return JSON.parse(resp.net_http_res.read_body)["token"]
      else
        return false
      end
    end

    def validated?(token="", ip="127.0.0.1")
      rest_client = RestClient::Resource.new @crowd_url, :user => @crowd_app_name, :password => @crowd_app_pass

      begin
        resp = rest_client["#{@crowd_auth_uri}/session/#{token}.json"].post json_validated(ip), :content_type => "application/xml", :accept => "application/json"
      rescue RestClient::ResourceNotFound
        return false
      end

      case resp.code
      when 200 then return true
      else return false
      end
    end
    
    private
      def json_session(username="", password="")
        return JSON.parse('{"username":"#{username}",
                            "password":"#{password}",
                            "validation-factors": {
                              "validationFactors":[{"name":"factor1", "value":"value1"}]
                              }
                            }')
      end
      
      def json_validated (ip="")
        return JSON.parse('{"validationFactors": [{"name": "remote_address", "value": "#{ip}"}]}')
      end

  end
end