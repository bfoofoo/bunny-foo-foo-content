module Statistics
  class QuestionsStatistics < Statistics::BaseStatistic
    DEFAULT_CHART_RESPONSE = {
      categories: [],
      series: []
    }

    def answers_counter_s_charts
      total_chart_statistics(DEFAULT_CHART_RESPONSE)
    end

    def total_chart_statistics(hash)
      hash[:categories] = categories
      hash[:series] = series 
      return hash
    end

    def categories
      questions.map do |question|
        {
          name: question.text,
          categories: S_FIELDS
        }
      end
    end

    def series 
      answers_hash = {}
      questions.each do |question|
        answers = question.answers
        S_FIELDS.each do |field|
          answers_hash = fill_answers_hash(answers_hash, field, question, answers)
        end
      end
      return answer_hash_to_flat_list(answers_hash)
    end

    private 

    def fill_answers_hash(answers_hash, field, question, answers)
      answers.each do |answer|
        answer_text = answer.text.downcase
        answers_hash[question.id] ||= default_answer_hash.deep_dup
        answers_hash[question.id][answer_text][field] = answer.formsite_user_answers.select {|user_answer| 
            user_answer.answer_id ==  answer.id && !user_answer.formsite_user[field].blank?
        }.count
      end
      return answers_hash
    end

    def answer_hash_to_flat_list hash
      response = answer_texts_hash
      hash.each do |question_id, question_answer_hash|
        question_answer_hash.each do |answer_text, s_counter_hash|
          response[answer_text].concat s_counter_hash.map {|key, value| value}
        end
      end
      response.map {|key, value| {name: key, data: value}}
    end


    def default_answer_hash
      return @default_answer_hash if !@default_answer_hash.blank?
      response = answer_texts_hash.deep_dup
      response.each do |key, value| 
        response[key] = s_fields_hash
      end
      return response
    end

    def answer_texts_hash
      return @answer_texts_hash if !@answer_texts_hash.blank?
      texts = answers.pluck(:text).uniq.map {|text| text.downcase}
      return @answer_texts_hash = Hash[ texts.collect { |field| [field, []] } ]
    end

    def s_fields_hash
      return @s_fields_hash if !@s_fields_hash.blank?
      @s_fields_hash = Hash[ S_FIELDS.collect { |field| [field, 0] } ]
    end
  end
end