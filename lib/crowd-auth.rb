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

      xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
      <authentication-context>
        <username>#{username}</username>
        <password>#{password}</password>
        <validation-factors>
          <validation-factor>
            <name>remote_address</name>
            <value>127.0.0.1</value>
          </validation-factor>
        </validation-factors>
      </authentication-context>"

      resp = rest_client["#{@crowd_auth_uri}/session.json"].post xml, :content_type => "application/xml"
      if resp.code == 201
        return JSON.parse(resp.message)["token"]
      else
        return false
      end
    end

    def validated?(token="", ip="127.0.0.1")
      rest_client = RestClient::Resource.new @crowd_url, :user => @crowd_app_name, :password => @crowd_app_pass

      xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
      <validation-factors>
        <validation-factor>
          <name>remote_address</name>
          <value>#{ip}</value>
        </validation-factor>
      </validation-factors>"

      resp = rest_client["#{@crowd_auth_uri}/session/#{token}.json"].post xml, :content_type => "application/xml", :accept => "application/json"

      case resp.code
      when 200 then return true
      when 404 then return false
      else return false
      end
    end
  end
end