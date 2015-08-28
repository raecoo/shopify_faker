module ShopifyFaker
  module RSpec
    module Fabrication
      extend ActiveSupport::Concern

      included do
        let(:shopify_product)   { attributes_for(:shopify_product, variants: shopify_variants, images: shopify_images) }
        let(:shopify_variants)  { [shopify_variant] }
        let(:shopify_images)    { [shopify_image] }

        let(:shopify_variant) { attributes_for(:shopify_variant, id: variant_id, title: variant_title, image_id: image_id) }
        let(:shopify_image)   { attributes_for(:shopify_image, id: image_id, position: position, variant_ids: variant_ids) }
        let(:variant_ids)     { [variant_id] }
        let(:variant_id)      { Faker::Number.number(12).to_i }
        let(:product_id)      { Faker::Number.number(12).to_i }
        let(:image_id)        { Faker::Number.number(12).to_i }

        let(:product_title)   { Faker::Commerce.product_name }
        let(:product_type)    { Faker::Lorem.word }
        let(:variant_title)   { Faker::Commerce.product_name }
        let(:position)        { rand(10) }
        let(:vendor)          { Faker::Company.name }
        let(:handle)          { Faker::Internet.slug(Faker::Company.bs) }
      end

      def attributes_for(*args)
        Fabricate.attributes_for(*args)
      end
    end
  end
end
