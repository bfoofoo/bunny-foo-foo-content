module Esp
  module ListMethods
    extend ActiveSupport::Concern

    def id_with_type
      "#{model_name.name}_#{self.id}"
    end

    def full_name
      return name if account_display_name.blank?
      "#{account_display_name} - #{name}"
    end

    private

    def account_display_name
      raise NotImplementedError
    end
  end
end