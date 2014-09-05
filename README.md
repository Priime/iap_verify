WFiapVerify
===========

Verify in app purchase gem

Based on Venice gem https://github.com/nomad/Venice. Venice does not work with iOS7 receipts.

Just an update on parsing. 

## Installation

```ruby
  data = "(Base64-Encoded Receipt Data)"
  if receipt = IapVerify::Receipt_iOS7.verify(data)
    p receipt.to_h
  end
```


## Usage
    gem install iap_verify


