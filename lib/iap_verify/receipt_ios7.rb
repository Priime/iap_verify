require 'venice'

module IapVerify
  class Receipt_iOS7

    attr_reader :application_version
    attr_reader :bundle_id
    attr_accessor :in_app
    attr_reader :receipt_type
    attr_reader :original_purchase_date
    attr_reader :original_application_version
    attr_reader :original_transaction_id
    attr_reader :request_date
    attr_reader :is_trial_period
    attr_reader :product_id
    attr_reader :purchase_date
    attr_reader :transaction_id
    attr_reader :quantity

    def initialize(attributes = {})

      @original_application_version = attributes['original_application_version'] if attributes['original_application_version']
      @application_version = attributes['application_version'] if attributes['application_version']
      @bundle_id = attributes['bundle_id'] if attributes['bundle_id']
      @receipt_type = attributes['receipt_type'] if attributes['receipt_type']
      @request_date = DateTime.parse(attributes['request_date']) if attributes['request_date']


      if attributes['in_app']
        @in_app = Array.new
        attributes['in_app'].each do |purchase|
          @in_app << Receipt_iOS7.new(purchase)
        end
       end

      @original_purchase_date = DateTime.parse(attributes['original_purchase_date']) if attributes['original_purchase_date']


      if attributes != nil & attributes['in_app'].nil?
        @is_trial_period = attributes['is_trial_period'] if attributes['is_trial_period']
        @original_transaction_id = attributes['original_transaction_id'] if attributes['original_transaction_id']
        @product_id = attributes['product_id'] if attributes['product_id']
        @purchase_date = DateTime.parse(attributes['purchase_date']) if attributes['purchase_date']
        @transaction_id = attributes['transaction_id'] if attributes['transaction_id']
        @quantity =  Integer(attributes['quantity']) if attributes['quantity']
      end
    end

    def to_h
      {
          :bundle_id => @bundle_id,
          :receipt_type => @receipt_type,
          :original_transaction_id => (@original_transaction_id.transaction_id rescue nil),
          :original_purchase_date => (@original_purchase_date.purchase_date.httpdate rescue nil),
          :in_app => @in_app.map{ |purchase| {is_trial_period: purchase.is_trial_period,
                                              product_id: purchase.product_id,
                                              purchase_date: (purchase.purchase_date.httpdate rescue nil),
                                              transaction_id: (purchase.transaction_id rescue nil),
                                              quantity: purchase.quantity,
                                              original_purchase_date: (purchase.original_purchase_date.httpdate rescue nil),
                                              original_transaction_id: (purchase.original_transaction_id rescue nil)
                                              }
          }
      }
    end

    def to_json
      self.to_h.to_json
    end

    class << self

      def verify(data, options = {})
        verify!(data, options) #rescue false
      end

      def verify!(data, options = {})
        client = IapVerify::Client.production

        begin
          client.verify!(data, options)
        rescue VerificationError => error
          case error.code
            when 21007
              client = IapVerify::Client.development
              retry
            when 21008
              client = IapVerify::Client.production
              retry
            else
              raise error
          end
        end
      end

      alias :validate :verify
      alias :validate! :verify!
    end

    class VerificationError < StandardError
      attr_accessor :code

      def initialize(code)
        @code = Integer(code)
      end

      def message
        case @code
          when 21000
            "The App Store could not read the JSON object you provided."
          when 21002
            "The data in the receipt-data property was malformed."
          when 21003
            "The receipt could not be authenticated."
          when 21004
            "The shared secret you provided does not match the shared secret on file for your account."
          when 21005
            "The receipt server is not currently available."
          when 21006
            "This receipt is valid but the subscription has expired. When this status code is returned to your server, the receipt data is also decoded and returned as part of the response."
          when 21007
            "This receipt is a sandbox receipt, but it was sent to the production service for verification."
          when 21008
            "This receipt is a production receipt, but it was sent to the sandbox service for verification."
          else
            "Unknown Error: #{@code}"
        end
      end
    end
  end
end
