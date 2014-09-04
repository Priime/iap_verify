module IapVerify
  class Client < Venice::Client
    def verify!(data, options = {})
      json = json_response_from_verifying_data(data)
      status, receipt_attributes = json['status'].to_i, json['receipt']

      case status
        when 0, 21006
          receipt = Receipt_iOS7.new(receipt_attributes)

          if latest_receipt_attributes = json['latest_receipt_info']
            receipt.latest = Receipt_iOS7.new(latest_receipt_attributes)
          end

          if latest_expired_receipt_attributes = json['latest_expired_receipt_info']
            receipt.latest_expired = Receipt_iOS7.new(latest_expired_receipt_attributes)
          end

          return receipt
        else
          raise Receipt_iOS7::VerificationError.new(status)
      end
    end
  end
end