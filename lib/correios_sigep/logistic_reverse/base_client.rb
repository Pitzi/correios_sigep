module CorreiosSigep
  module LogisticReverse
    class BaseClient
      def initialize
        @client = Savon.client(wsdl: wsdl, log: true, logger: Rails.logger, open_timeout: 12, read_timeout: 12, pretty_print_xml: true, log_level: :info, filters: [:cod_administrativo, :contrato, :codigo_servico, :cartao])
      end

      def wsdl
        @wsdl ||= if ENV['GEM_ENV'] == 'test'
                    'http://webservicescolhomologacao.correios.com.br/ScolWeb/WebServiceScol?wsdl'
                  else
                    'http://webservicescol.correios.com.br/ScolWeb/WebServiceScol?wsdl'
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
