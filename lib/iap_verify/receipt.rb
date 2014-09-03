module IapVerify
  class Receipt
    attr_reader :environment
    attr_reader :application_version
    attr_reader :bundle_id
    attr_accessor :in_app
    attr_reader :receipt_type
    attr_reader :status
    attr_reader :original_purchase_date
    attr_reader :original_application_version
    attr_reader :original_transaction_id
    attr_reader :request_date

  end
end