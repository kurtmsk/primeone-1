class Policy < ActiveRecord::Base
  # Validations
  validates :policy_number, presence: true, uniqueness: true

  # Associations
  belongs_to :broker

  # Serializations
  # Hash values for the policy (and their outlines)
  serialize :insured, Hash
  # { name, quoted_by, date, dba, type_business, mortgagee, type_insured }

  serialize :mailing_address, Hash
  # { street, city, state, zip }

  serialize :agency, Hash
  # { contact, name, email }

  serialize :property, Hash
  # { locations: {
    # location_1: {
      # co_insurance, co_insurance_factor, deductible, deductible_factor,
      # address: { street, city, state, zip },
      # building_exposure: { type_of_business, coverage_type, protection_class,
        # updates, year_built, construction_type, number_stories, square_feet,
        # parking_lot_square_feet
        # },
      # food_spoilage: { facticity, limit, rate, premium },
      # theft: { facticity, limit, rate, premium },
      # property_enhancement: { facticity, limit, rate, premium },
      # mechanical_breakdown: { facticity, limit, rate, premium },
      # exposures: {
        # building: { name, valuation, limit, rate, ded_factor, co_ins_factor, premium },
        # bpp:{ name, valuation, limit, rate, ded_factor, co_ins_factor, premium,},
        # earnings: { name, valuation, limit, rate, ded_factor, co_ins_factor, premium },
        # sign: { name, valuation, limit, rate, ded_factor, co_ins_factor, premium },
        # pumps: { name, valuation, limit, rate, ded_factor, co_ins_factor, premium },
        # canopies: { name, valuation, limit, rate, ded_factor, co_ins_factor, premium },
        # other: { name, valuation, limit, rate, ded_factor, co_ins_factor, premium }
      # },
      # location_1_property_premium }
    # },
  # property_schedule_rating_pct, property_premium_subtotal, property_premium_total
  # }

  serialize :crime, Hash
  # { central_burglar_alarm, exclude_safe, deductible,
    # employee_theft: { limit, premium },
    # forgery_alteration: { limit, premium },
    # money_securities: { limit, premium },
    # safe_burglary: { limit, premium },
    # premises: { limit, premium },
    # crime_schedule_rating, crime_subtotal, crime_total_premium
  # }

  serialize :general_liability, Hash
  # { limits: { general_aggregate, products_completed_operations,
      # personal_advertising_injury, each_occurence, fire_damage,
      # medical_expense
      # },
  # territory, additional_insureds_number, water_gas_tank, rate,
  # gas_premium, gl_subtotal, multi_location_factor, total_schedule_rating,
  # total_gl_premium, gl_comments,
  # gl_exposures: {
    # exposure_1: { loc_number, cov, class_description, code, premium_basis,
      # type, base_rate, ilf, premium },
    # exposure_2: { loc_number, cov, class_description, code, premium_basis,
      # type, base_rate, ilf, premium },
    # exposure_3: { loc_number, cov, class_description, code, premium_basis,
      # type, base_rate, ilf, premium },
    # exposure_4: { loc_number, cov, class_description, code, premium_basis,
      # type, base_rate, ilf, premium }
    # }
  # }

  serialize :commercial_auto, Hash
  # { facticity, locations, hired_auto, hired_auto_premium, total_auto_premium }

  # best_in_place with Serialized fields
  # forewards the arguments to the correct methods
  def method_missing(method_name, *arguments, &block)
    if method_name.to_s =~ /data__(.+)\=/
      keys = method_name.to_s.match(/data__(.+)=/)[1].split("__")
      self.send('data_setter', keys, arguments.first, method_name)
    elsif method_name.to_s =~ /data__(.+)/
      keys = method_name.to_s.split("__")
      self.send('data_getter', keys)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false) # prevents giving UndefinedMethod error
    method_name.to_s.start_with?('data_') || super
  end

  def data_getter(keys)
    ret = self
    keys.drop(1).each do |key|
      ret = ret[key.to_sym]
    end
    ret
  end

  # the method returns value because best_in_place sets the returned value as text
  def data_setter(keys, value, mn)
    case keys.length
    when 2
      self[keys[0].to_sym][keys[1].to_sym] = value
    when 3
      self[keys[0].to_sym][keys[1].to_sym][keys[2].to_sym] = value
    when 4
      self[keys[0].to_sym][keys[1].to_sym][keys[2].to_sym][keys[3].to_sym] = value
    when 5
      self[keys[0].to_sym][keys[1].to_sym][keys[2].to_sym][keys[3].to_sym][keys[4].to_sym] = value
    end
  end

end
