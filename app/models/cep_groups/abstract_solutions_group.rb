class AbstractSolutionsGroup < CepGroup
  def provider
    'AbstractSolutions'
  end

  def full_name
    "#{account.username} - #{name}"
  end
end