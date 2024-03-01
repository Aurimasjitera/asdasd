module HairStylistsService
  class Index
    def initialize(stylist_id)
      @stylist_id = stylist_id
    end

    def execute
      # Fetch treatment plan requests for the given hair stylist
      # Assuming TreatmentPlanRequest model has a scope or class method to fetch requests for a stylist
      requests = TreatmentPlanRequest.for_stylist(@stylist_id)
      { requests: requests }
    end
  end
end
