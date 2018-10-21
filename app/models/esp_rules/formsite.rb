module EspRules
  class Formsite < EspRule
    belongs_to :formsite, as: :source
  end
end
