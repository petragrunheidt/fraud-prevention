require 'rails_helper'

RSpec.describe Transaction, type: :model do
  context 'when validating attributes' do
    %i[
      transaction_amount
      transaction_date
      user_id
      merchant_id
      card_number
    ].each do |attribute|
      it { is_expected.to validate_presence_of(attribute) }
    end
  end
end
