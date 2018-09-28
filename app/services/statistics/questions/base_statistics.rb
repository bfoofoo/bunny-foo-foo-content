module Statistics
  module Questions
    class BaseStatistics < Statistics::BaseStatistic
      DROP_OFF_KEY="Drop off"
      DEFAULT_CHART_RESPONSE = {
        categories: [],
        series: []
      }

      def initialize(params={})
        super
        @start_date = params[:start_date] || Date.yesterday
        @end_date = params[:end_date] || Date.yesterday
      end
  
      def total_chart_statistics(hash)
        hash[:categories] = categories
        hash[:series] = series 
        return hash
      end
  
      def categories
        filtered_questions.map do |question|
          if !type_fields.blank?
            {
              name: question_identification(question),
              categories: type_fields
            }
          else
            question_identification(question)
          end
        end
      end
  
      def series 
        answers_hash = {}
        filtered_questions.each_with_index do |question, index|
          answers = question.answers
          if total_stats
            answers_hash = fill_answers_hash_total(answers_hash, question, answers, index)
          else
            type_fields.each do |field|
              answers_hash = fill_answers_hash(answers_hash, field, question, answers, index)
            end
          end
        end
        return answer_hash_to_flat_list(answers_hash)
      end
  
      def formsite
        return @formsite if !@formsite.blank?
        @formsite = 
          if !formsite_id.blank?
            Formsite.find_by_id(formsite_id)
          else
            formsites.first
          end
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
  
      def question_identification(question)
        "Q#{question.position}"
      end

      def fill_answers_hash_total answers_hash, question, answers, question_index
        answers.each do |answer|
          answer_text = answer.text.downcase
          answers_hash[question_identification(question)] ||= default_answer_hash.deep_dup
          answers_hash[question_identification(question)][answer_text] = answers_count(answer)
          answers_hash[question_identification(question)][DROP_OFF_KEY] = calculate_drop_off(question_index)
        end
        return answers_hash
      end
  
      def fill_answers_hash(answers_hash, field, question, answers, question_index)
        answers.each do |answer|
          answer_text = answer.text.downcase
          answers_hash[question_identification(question)] ||= default_answer_hash.deep_dup
          answers_hash[question_identification(question)][answer_text][field] = answers_count(answer, field)
          answers_hash[question_identification(question)][DROP_OFF_KEY] = calculate_drop_off(question_index)
        end
        return answers_hash
      end
  
      def filtered_formsite_user_answers(answer)
        if !start_date.blank? && !end_date.blank?
          answer.formsite_user_answers.includes(:formsite_user).between_dates(start_date.to_date.beginning_of_day, end_date.to_date.end_of_day)
        else
          answer.formsite_user_answers.includes(:formsite_user)
        end
      end

      def calculate_drop_off question_index
        if question_index == 0
          question = filtered_questions[question_index]
          submitted_users.count - answers_count_by_question(question)
        else
          prev_question = filtered_questions[question_index - 1]
          question = filtered_questions[question_index]
          answers_count_by_question(prev_question) - answers_count_by_question(question) 
        end
      end

      def answers_count_by_question(question)
        answers = question.formsite_user_answers.includes(:formsite_user).between_dates(start_date.to_date.beginning_of_day, end_date.to_date.end_of_day)

        answers = answers.select{|user_answer| !user_answer.formsite_user.blank? && user_answer.formsite_user.is_verified}

        FormsiteUserAnswer.where(id: answers.pluck(:id)).count
      end
  
      def answer_hash_to_flat_list hash
        response = answer_texts_hash
        hash.each do |question_id, question_answer_hash|
          question_answer_hash.each do |answer_text, s_counter_hash|
            if s_counter_hash.is_a? Integer
              response[answer_text] << s_counter_hash
            else
              value = s_counter_hash.blank? ? [0] : s_counter_hash.map {|key, value| value}
              response[answer_text].concat value
            end
          end
        end
        response.map {|key, value| {name: key, data: value}}
      end
  
      def default_answer_hash
        return @default_answer_hash if !@default_answer_hash.blank?
        response = answer_texts_hash.deep_dup
        response.each do |key, value| 
          response[key] = type_fields_hash
        end
        return response
      end
  
      def answer_texts_hash
        return @answer_texts_hash if !@answer_texts_hash.blank?
        texts = filtered_answers
                  .sort!{ |a, b|  a.id <=> b.id } 
                  .pluck(:text).uniq
                  .map {|text| text.downcase}
                  .concat([DROP_OFF_KEY])
        return @answer_texts_hash = Hash[ texts.collect { |field| [field, []] } ]
      end

      def type_fields_hash
        return @s_fields_hash if !@s_fields_hash.blank?
        @s_fields_hash = Hash[ type_fields.collect { |field| [field, 0] } ]
      end

      def submitted_users
        @submitted_users ||= formsite_users.is_verified
      end
    end
  end
end
