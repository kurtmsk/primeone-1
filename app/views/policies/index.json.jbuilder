json.array!(@policies) do |policy|
  json.extract! policy, :id, :policy_number, :client_code, :name, :effective_date, :status, :broker
  json.url policy_url(policy, format: :json)
end
