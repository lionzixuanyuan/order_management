json.array!(@order_details) do |order_detail|
  json.extract! order_detail, :id, :order_id, :product_id, :amount, :discount, :sum
  json.url order_detail_url(order_detail, format: :json)
end
