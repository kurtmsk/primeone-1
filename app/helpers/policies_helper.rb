module PoliciesHelper
  def displayPropertyPremium(value)
    if value.to_i != 0
      number_to_currency(value,format:"%n")
    else
      "Excluded"
    end
  end
end
