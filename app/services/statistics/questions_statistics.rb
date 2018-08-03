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
      filtered_questions.map do |question|
        {
          name: question.id,
          categories: filtered_s_fields
        }
      end
    end

    def series 
      answers_hash = {}
      filtered_questions.each do |question|
        answers = question.answers
        filtered_s_fields.each do |field|
          answers_hash = fill_answers_hash(answers_hash, field, question, answers)
        end
      end
      return answer_hash_to_flat_list(answers_hash)
    end

    private 
    def filtered_questions
      return @filtered_questions if !@filtered_questions.blank?
      @filtered_questions = 
        if formsite_selected?
          questions.where(formsite_id: formsite.id)
        else
          questions
        end
    end

    def fill_answers_hash(answers_hash, field, question, answers)
      answers.each do |answer|
        answer_text = answer.text.downcase
        answers_hash[question.id] ||= default_answer_hash.deep_dup
        answers_hash[question.id][answer_text][field] = answers_count(answer, field)
      end
      return answers_hash
    end

    def answers_count answer, field
      filtered_formsite_user_answers(answer).select {|user_answer| 
        user_answer.answer_id ==  answer.id && !user_answer.formsite_user[field].blank?
      }.count
    end

    def filtered_formsite_user_answers answer
      if !start_date.blank? && !end_date.blank?
        answer.formsite_user_answers.select { |user_answer|
          user_answer.created_at >= start_date && user_answer.created_at <= end_date
        }
      else
        answer.formsite_user_answers
      end
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
      texts = filtered_answers.pluck(:text).uniq.map {|text| text.downcase}
      return @answer_texts_hash = Hash[ texts.collect { |field| [field, []] } ]
    end

    def s_fields_hash
      return @s_fields_hash if !@s_fields_hash.blank?
      @s_fields_hash = Hash[ filtered_s_fields.collect { |field| [field, 0] } ]
    end
  end
end