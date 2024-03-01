json.status 201
json.treatment_plan_request do
  json.id treatment_plan_request.id
  json.user_id treatment_plan_request.user_id
  json.area treatment_plan_request.area
  json.status treatment_plan_request.status
  json.created_at treatment_plan_request.created_at
end
