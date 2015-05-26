json.array!(@policies) do |policy|
  json.extract! policy, :id, :policy_number, :insured
  json.url policy_url(policy, format: :json)
end
