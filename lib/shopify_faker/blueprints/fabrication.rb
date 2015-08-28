require 'fabrication'
require 'fabrication/syntax/make'

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

  option1 "Small"
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
