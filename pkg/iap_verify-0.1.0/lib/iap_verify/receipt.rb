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



    def initialize(attributes = {})
      @environment
      @application_version
      @bundle_id
      @in_app
      @receipt_type
      @status
      @original_purchase_date
      @original_application_version
      @original_transaction_id
      @request_date

      @quantity = Integer(attributes['quantity']) if attributes['quantity']
      @product_id = attributes['product_id']
      @transaction_id = attributes['transaction_id']
      @purchase_date = DateTime.parse(attributes['purchase_date']) if attributes['purchase_date']
      @app_item_id = attributes['app_item_id']
      @version_external_identifier = attributes['version_external_identifier']
      @bid = attributes['bid']
      @bvrs = attributes['bvrs']

      # expires_date is in ms since the Epoch, Time.at expects seconds
      @expires_at = Time.at(attributes['expires_date'].to_i / 1000) if attributes['expires_date']

      if attributes['original_transaction_id'] || attributes['original_purchase_date']
        original_attributes = {
            'transaction_id' => attributes['original_transaction_id'],
            'purchase_date' => attributes['original_purchase_date']
        }

        self.original = Receipt.new(original_attributes)
      end
    end

    def to_h
      {
          :quantity => @quantity,
          :product_id => @product_id,
          :transaction_id => @transaction_id,
          :purchase_date => (@purchase_date.httpdate rescue nil),
          :original_transaction_id => (@original.transaction_id rescue nil),
          :original_purchase_date => (@original.purchase_date.httpdate rescue nil),
          :app_item_id => @app_item_id,
          :version_external_identifier => @version_external_identifier,
          :bid => @bid,
          :bvrs => @bvrs,
          :expires_at => (@expires_at.httpdate rescue nil)
      }
    end

    def to_json
      self.to_h.to_json
    end

    class << self
      def verify(data, options = {})
        verify!(data, options) rescue false
      end

      def verify!(data, options = {})
        client = Client.production

        begin
          client.verify!(data, options)
        rescue VerificationError => error
          case error.code
            when 21007
              client = Client.development
              retry
            when 21008
              client = Client.production
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