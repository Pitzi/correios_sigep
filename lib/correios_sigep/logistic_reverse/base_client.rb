module CorreiosSigep
  module LogisticReverse
    class BaseClient
      def initialize
        @client = Savon.client(headers: { 'SOAPAction' => ''}, basic_auth: [CorreiosSigep.configuration.basic_auth_user, CorreiosSigep.configuration.basic_auth_password], wsdl: wsdl, log: true, logger: Rails.logger, open_timeout: 12, read_timeout: 12, pretty_print_xml: true, log_level: :debug, filters: [:cod_administrativo, :contrato, :codigo_servico, :cartao])
      end

      def wsdl
        @wsdl ||= if ENV['GEM_ENV'] == 'test'
                    'https://apphom.correios.com.br/logisticaReversaWS/logisticaReversaService/logisticaReversaWS?wsdl'
                  else
                    'https://cws.correios.com.br/logisticaReversaWS/logisticaReversaService/logisticaReversaWS?wsdl'
                  end
      end

      def invoke(method, message)
        @client.instance_variable_set(
          :@wsdl,
          Wasabi::Document.new(CorreiosSigep.configuration.wsdl_base_url)
        ) if wsdl_base_url_changed?

        @client.call(method, message: message)
      end

      private
      def wsdl_base_url_changed?
        wsdl_base_url && wsdl_base_url != @client.instance_variable_get(:@wsdl).document
      end

      def wsdl_base_url
        CorreiosSigep.configuration.wsdl_base_url
      end
    end
  end
end
