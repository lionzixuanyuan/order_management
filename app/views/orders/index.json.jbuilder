json.array!(@orders) do |order|
  json.extract! order, :id, :code, :customer_id, :totle_amount, :totle_sum, :inceptor, :saleman, :creator_id, :state
  json.url order_url(order, format: :json)
end
