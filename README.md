Web Factory iap_verify
===========

Verify in app purchase from Apple

Based on Venice gem https://github.com/nomad/Venice. Venice does not work with iOS7 receipts.

Just an update on parsing. 

## Usage
    gem install iap_verify

## Installation

```ruby
data = "(Base64-Encoded Receipt Data)"
if receipt = IapVerify::Receipt_iOS7.verify(data)
    p receipt.to_h
end
```


