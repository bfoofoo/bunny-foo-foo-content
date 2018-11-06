module Onepoint
  class Contacts < Contact
    def create(params)
      p create_params(params)
      super
    end

    private

    def base_path
      'contacts'
    end

    def create_params(data)
      data.map do |item|
        super(item)
      end
    end
  end
end
