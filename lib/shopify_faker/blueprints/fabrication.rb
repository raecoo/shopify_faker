require 'fabrication'
require 'fabrication/syntax/make'
require 'faker'

class Sham
  def Sham.func(name, f)
    singleton_class.instance_eval do
      define_method(name) { f }
    end
  end

  func :email,       -> { Faker::Internet.email }
end

Fabricator(:shopify_variant, class_name: 'Hash') do
  initialize_with { raise 'Use attributes_for' }

  id         { Faker::Number.number(18).to_i }
  product_id { Faker::Number.number(18).to_i }
  title      { Faker::Commerce.product_name }
  price      { Faker::Commerce.price }
  sku        { SecureRandom.urlsafe_base64 }
  position   { rand(10) }
  grams      { rand(200) }

  inventory_policy      "deny"
  compare_at_price      { Faker::Commerce.price }
  fulfillment_service   "manual"
  inventory_management  nil

  option1 { Faker::Lorem.word }
  option2 nil
  option3 nil

  created_at        { (rand(100) + 1).days.ago.to_datetime.rfc3339 }
  updated_at        { (Time.now.utc - (rand(100) + 1).hours).to_datetime.rfc3339 }
  requires_shipping { rand > 0.25 }
  taxable           { rand > 0.1 }
  barcode           nil

  inventory_quantity     { rand(100) }
  old_inventory_quantity { rand(100) }

  image_id    { rand(9999999) + 1 }
  weight      { rand(25) }
  weight_unit nil

  after_build(&:stringify_keys!)
end

Fabricator(:shopify_image, class_name: 'Hash') do
  initialize_with { raise 'Use attributes_for' }

  id         { Faker::Number.number(18).to_i }
  product_id { Faker::Number.number(18).to_i }
  position   { rand(10) }
  src        { "//cdn.shopify.com/s/assets/shopify_shirt-#{SecureRandom.hex(32)}.png" }

  created_at        { (rand(100) + 1).days.ago.to_datetime.rfc3339 }
  updated_at        { (Time.now.utc - (rand(100) + 1).hours).to_datetime.rfc3339 }

  variant_ids []

  after_build(&:stringify_keys!)
end

Fabricator(:shopify_product, class_name: 'Hash') do
  initialize_with { raise 'Use attributes_for' }

  id              { Faker::Number.number(18).to_i }
  title           { Faker::Commerce.product_name }
  vendor          { Faker::Company.name }
  product_type    { Faker::Lorem.word }
  handle          { Faker::Internet.slug(Faker::Company.bs) }

  variants        { Array.new(rand(10) + 1) { Fabricate.attributes_for(:shopify_variant) } }
  images          { Array.new(rand(10) + 1) { Fabricate.attributes_for(:shopify_image) } }

  created_at      { (rand(100) + 1).days.ago.to_datetime.rfc3339 }
  updated_at      { (Time.now.utc - (rand(100) + 1).hours).to_datetime.rfc3339 }
  published_at    { (Time.now.utc - (rand(100) + 1).minutes).to_datetime.rfc3339 }
  tags            { Faker::Lorem.words.join(', ') }
  template_suffix nil
  published_scope 'global'
  body_html       { "<p>#{Faker::Lorem.paragraph}</p>" }

  after_build(&:stringify_keys!)
end

Fabricator(:credit_card, class_name: 'Hash') do
  initialize_with { raise 'Use attributes_for' }

  credit_card_number  { Faker::Business.credit_card_number }
  credit_card_company { Faker::Business.credit_card_type }
  credit_card_bin     nil
  avs_result_code     nil
  cvv_result_code     nil

  after_build(&:stringify_keys!)
end

Fabricator(:shopify_customer, class_name: 'Hash') do
  initialize_with { raise 'Use attributes_for' }

  id                { Faker::Number.number(18).to_i }
  email             { |attributes| attributes[:email] || Faker::Internet.safe_email }
  first_name        { Faker::Name.first_name }
  last_name         { Faker::Name.last_name }
  created_at        { (rand(100) + 1).days.ago.to_datetime.rfc3339 }
  updated_at        { (Time.now.utc - (rand(100) + 1).hours).to_datetime.rfc3339 }
  total_spent       { Faker::Number.decimal(2) }
  default_address   { Fabricate.attributes_for(:shopify_address) }
  accepts_marketing { rand > 0.3 }
  orders_count       0
  state              "disabled"
  last_order_id      nil
  last_order_name    nil
  note               nil
  verified_email     true
  tax_exempt         false
  tags               ""
  multipass_identifier nil

  after_build(&:stringify_keys!)
end

Fabricator(:shopify_address, class_name: 'Hash') do
  initialize_with { raise 'Use attributes_for' }

  name            { Faker::Name.name }
  first_name      { Faker::Name.first_name }
  last_name       { Faker::Name.last_name }
  company         { Faker::Company.name }
  address1        { '6009 Westline Dr' }
  city            { 'Houston' }
  zip             { '77036' }
  province        { 'Texas' }
  country         { 'United States' }
  country_code    { 'US' }
  province_code   { 'TX' }

  after_build(&:stringify_keys!)
end

Fabricator(:shopify_line_item, class_name: 'Hash') do
  initialize_with { raise 'Use attributes_for' }

  id                    { Faker::Number.number(18).to_i }
  variant_id            { |attributes| attributes[:variant_id] || Faker::Number.number(18).to_i }
  product_id            { |attributes| attributes[:product_id] || Faker::Number.number(18).to_i }
  title                 { Faker::Commerce.product_name }
  name                  { Faker::Commerce.product_name }
  price                 { Faker::Commerce.price }
  quantity              { rand(10)}
  grams                 { rand(500)}
  sku                   { SecureRandom.urlsafe_base64 }
  variant_title         { Faker::Commerce.color }
  requires_shipping     { rand > 0.25 }
  taxable               { rand > 0.1 }
  properties            []
  gift_card             false
  product_exists        true
  variant_inventory_management nil
  fulfillable_quantity  { rand(10) }
  fulfillment_service   "manual"
  fulfillment_status    nil
  # tax_lines             { Array.new(rand(10) + 1) { Fabricate.attributes_for(:shopify_tax_line_item) } }

  after_build(&:stringify_keys!)
end

Fabricator(:shopify_tax_line_item, class_name: 'Hash') do
  initialize_with { raise 'Use attributes_for' }

  title   { Faker::Commerce.product_name }
  price   { Faker::Commerce.price }
  rate    { rand.round(2) }

  after_build(&:stringify_keys!)
end

Fabricator(:shopify_shipping_line_item, class_name: 'Hash') do
  initialize_with { raise 'Use attributes_for' }

  title       { Faker::Commerce.product_name }
  price       { Faker::Commerce.price }
  code        { Faker::Commerce.product_name }
  source      "shopify"

  after_build(&:stringify_keys!)
end

Fabricator(:shopify_refund, class_name: 'Hash') do
  initialize_with { raise 'Use attributes_for' }

  id                { Faker::Number.number(18).to_i }
  note              { Faker::Lorem.sentence }
  created_at        { (rand(100) + 1).days.ago.to_datetime.rfc3339 }
  refund_line_items { Array.new(rand(10) + 1) { Fabricate.attributes_for(:shopify_refund_line_item) } }
  transactions      { Array.new(rand(10) + 1) { Fabricate.attributes_for(:shopify_transaction_line_item) } }
  restock           { rand > 0.35 }
  user_id           { Faker::Number.number(18).to_i }

  after_build(&:stringify_keys!)
end

Fabricator(:shopify_refund_line_item, class_name: 'Hash') do
  initialize_with { raise 'Use attributes_for' }

  id            { Faker::Number.number(18).to_i }
  line_item     { Fabricate.attributes_for(:shopify_line_item) }
  line_item_id  { Faker::Number.number(18).to_i }
  quantity      { rand(5) + 1 }

  after_build(&:stringify_keys!)
end

Fabricator(:shopify_transaction_line_item, class_name: 'Hash') do
  initialize_with { raise 'Use attributes_for' }

  id              { Faker::Number.number(18).to_i }
  order_id        { Faker::Number.number(18).to_i }
  kind            "authorization"
  gateway         "bogus"
  message         nil
  created_at      { (rand(100) + 1).days.ago.to_datetime.rfc3339 }
  test            { rand > 0.35 }
  authorization   { Faker::Number.hexadecimal(30) }
  status          "success"
  amount          { Faker::Commerce.price }
  currency        "USD"
  payment_details { Fabricate.attributes_for(:credit_card) }

  after_build(&:stringify_keys!)
end

Fabricator(:shopify_order, class_name: 'Hash') do
  initialize_with { raise 'Use attributes_for' }

  id            { Faker::Number.number(18).to_i }
  email         { Faker::Internet.safe_email }
  order_number  { Faker::Number.number(4).to_i }
  name          { |attributes| "##{attributes[:order_number] || Faker::Number.number(4).to_i}" }
  customer      { |attributes| Fabricate.attributes_for(:shopify_customer, email: attributes[:email]) }
  currency      "USD"

  after_build(&:stringify_keys!)
end
