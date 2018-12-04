require 'net/http'
require 'net/https'
require 'base64'
require 'savon'
require 'securerandom'

module EmailMarketerService
  module Netatlantic
    class AuthService

      def initialize
      end

      def test


        # realm = Base64.strict_encode64("apiuser@datadcides.com:API@20181010")
        # Savon.client(ntlm: ["username", "password"])
        client = Savon.client(
            ntlm: ["apiuser@datadcides.com", "API@20181010"],
            wsdl: "http://zoom.netatlantic.com:82/?wsdl",
            # basic_auth: ["apiuser@datadcides.com", "API@20181010"],
            soap_header: { 'Authorization:' => "apiuser@datadcides.com:API@20181010"},
            headers: {"Authorization" => "Basic"},
            log: true,
            pretty_print_xml: true
        )

        # client = Savon.client(
        #   wsdl: "http://zoom.netatlantic.com:82/?wsdl", 
        #   basic_auth: ["apiuser@datadcides.com", "API@20181010"]
        # )

        # class SomeApi
        #   def self.get(type, param)
        #     soap_action = "get_#{type}"
        #     client = Savon::Client.new WSDL
        
        #     client.send(soap_action) do |soap|
        #       soap.namespaces["xmlns:wsdl"] = "http://zoom.netatlantic.com:82/?wsdl"
        #       soap.header = { "wsdl:Credentials" => {
        #         "UserName" => :user, "Password" => :pass } }
        #       soap.body = { "wsdl:param" => param }
        #     end
        #   end
        # end
        # create a client for the service
        # client = Savon.client(wsdl: 'http://zoom.netatlantic.com:82/?wsdl')

        # client = Savon.client do
        #       wsdl "http://zoom.netatlantic.com:82/?wsdl"
        #       ntlm ["kasey@datadecides.com", "Fgoogle212"]
        #     end


        client.operations
        client.call(:api_version)
        # http = Net::HTTP.new('go.netatlantic.com', 82)
        # http.use_ssl = false
        # path = '/'


        # # SOAP Envelope
        # data = <<-EOF
        # <?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope
        # xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
        # xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
        # xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        # xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        # xmlns:ns1="http://tempuri.org/ns1.xsd"
        # xmlns:ns="http://www.lyris.com/lmapi">
        # <SOAP-ENV:Body>
        # <ns:CreateSingleMember>
        # <EmailAddress xsi:type="xsd:string">kasey@datadecides.com</EmailAddress>
        # <FullName xsi:type="xsd:string">Anthony Scotti</FullName>
        # <ListName xsi:type="xsd:string">mylistname</ListName>
        # </ns:CreateSingleMember>
        # </SOAP-ENV:Body>
        # </SOAP-ENV:Envelope>
        # EOF

        # # Set Headers
        # headers = {
        #   'Referer' => 'http://www.128bitstudios.com/',
        #   'Content-Type' => 'text/xml',
        #   'Host' => 'go.netatlantic.com',
        #   'Authorization' => 'Basic ' + Base64::encode64("kasey@datadecides.com:Fgoogle212")
        # }

        # # Post the request
        # resp, data = http.post(path, data, headers)

        # # Output
        # puts 'Code = ' + resp.code
        # puts 'Message = ' + resp.message
        # resp.each { |key, val| puts key + ' = ' + val }
        # puts data

      end

    end
  end
end
