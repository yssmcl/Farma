#encoding: utf-8
class MultipleAnswersValidator < ActiveModel::EachValidator
  include MathEvaluate

  def validate_each(record, attribute, value)
    exps = value.split(";")
    validades_size(record, attribute, value, exps)
    validades_equal(record, attribute, value, exps)
  end

  # Validades the size of multiples answers
  def validades_size(record, attribute, value, exps)
    if exps.size > options[:max]
      msg = "Não deve exister mais que #{options[:max]} respostas"
      record.errors[attribute] << msg
    end
  end

  # Validades equivalent answers
  # Only is allow equivalent answer when the order is consider
  def validades_equal(record, attribute, value, exps)
    if not(options[:allow_equal]) && exps.size > 1 && not(record.cmas_order)
      options = { variables: record.exp_variables }
      exps_2a2 = exps.combination(2).to_a
      equal = false

      exps_2a2.each do |exp|
        equal = MathEvaluate::Expression.eql?(exp[0], exp[1], options)
        break if equal
      end

      if equal
        msg = "Somente é considerado múltiplas respostas iguais se for considerado sua ordem"
        record.errors[attribute] << msg
      end
    end
  end
end
