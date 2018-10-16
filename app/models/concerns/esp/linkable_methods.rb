module Esp
  module LinkableMethods
    extend ActiveSupport::Concern

    included do
      has_many :aweber_list_users, class_name: 'EspListUsers::Aweber', as: :linkable
      has_many :aweber_lists, through: :aweber_list_users, source: :list, source_type: 'AweberList'
      has_many :adopia_list_users, class_name: 'EspListUsers::Adopia', as: :linkable
      has_many :adopia_lists, through: :adopia_list_users, source: :list, source_type: 'AdopiaList'
      has_many :elite_group_users, class_name: 'EspListUsers::Elite', as: :linkable
      has_many :elite_groups, through: :elite_group_users, source: :list, source_type: 'EliteGroup'

      scope :added_to_aweber, -> { joins(:aweber_lists).distinct }
      scope :added_to_adopia, -> { joins(:adopia_lists).distinct }
      scope :added_to_elite, -> { joins(:elite_groups).distinct }
    end

    ESP_LIST_TYPES = {
      aweber: :aweber_list,
      adopia: :adopia_list,
      elite: :elite_group
    }.freeze

    ESP_LIST_TYPES.each do |provider, type|
      define_method :"sent_to_#{provider}?" do
        send("#{type}_users").present?
      end

      define_method :"sent_to_#{type}?" do |item|
        send("#{type}_users").where(list: item).exists?
      end
    end
  end
end
