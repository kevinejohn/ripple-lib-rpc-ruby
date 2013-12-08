require File.expand_path('../../../spec_helper', __FILE__)

describe Ripple::Model::Transaction do
  context '#to_hash' do
    it 'should be successful' do
      transaction = Ripple::Model::Transaction.new({
        destination_account: '1',
        destination_amount: {
            value: '1',
            currency: 'XRP'
          },
        destination_tag: '2',
        invoice_id: '4'
        })

      hash = transaction.to_hash

      correct_hash = {
        destination: '1',
        amount: {
            value: '1',
            currency: 'XRP'
          },
        DestinationTag: '2',
        InvoiceID: '4'
        }

      hash.should be_eql(correct_hash)
    end
  end
end
