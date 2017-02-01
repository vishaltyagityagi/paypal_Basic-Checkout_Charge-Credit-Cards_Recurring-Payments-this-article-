  class Card < ActiveRecord::Base
  belongs_to :registration
  has_one :card_transaction
    has_one :course, through: :registration

  # These attributes won't be stored
  # attr_accessor :card_number, :card_verification

  # before_create :validate_card

  def purchase
    response = if course.recurring
                 GATEWAY.recurring(price_in_cents, credit_card, purchase_options)
               else
                 GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
               end
    create_card_transaction(action: "purchase", amount: price_in_cents, response: response)
    registration.update_attribute(:purchased_at, Time.now) if response.success?
    response.success?
  end


  def price_in_cents
    100
  end

  private

  def purchase_options
    values = {
            ip: ip_address,
            billing_address: {
                name:      "Flaying Cakes",
                address1:  "123 5th Av.",
                city:      "New York",
                state:     "NY",
                country:   "US",
                zip:       "10001"
            }
        }
    if course.recurring
      values.merge(
        period: course.period,
        frequency: 1,
        cycles: course.cycles,
        description: course.name,
        start_date: Time.now
      )
    else
      values
    end
  end


  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add :base, message
      end
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
        type:                card_type,
        number:              card_number,
        verification_value:  card_verification,
        month:               card_expires_on.month,
        year:                card_expires_on.year,
        first_name:          first_name,
        last_name:           last_name
    )
  end
end

