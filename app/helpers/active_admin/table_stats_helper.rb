module ActiveAdmin
  module TableStatsHelper
    def colorize_cell(max, value)
      "color: #00#{((value / max.to_f * 16).to_i - 1).to_s(16)}f00" if value > 0
    end
  end
end
