module CorreiosSigep
  class Configuration
    attr_accessor :administrative_code, :card, :contract, :password,
                  :service_code, :user, :wsdl_base_url, :basic_auth_user, :basic_auth_password
  end
end
