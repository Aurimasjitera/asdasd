json.status 200
json.treatment_plan_requests do
  json.array! treatment_plan_requests do |request|
    json.id request.id
    json.user_id request.user_id
    json.area request.area
    json.status request.status
    json.created_at request.created_at
  end
end
