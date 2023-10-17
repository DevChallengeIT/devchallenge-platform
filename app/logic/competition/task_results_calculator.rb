# frozen_string_literal: true

# TODO: Spec this
module Competition
  class TaskResultsCalculator
    def self.task_results_calculator(**args)
      new(**args)
    end

    attr_reader :task, :results

    def initialize(task:)
      @task = task
      @results = Competition.task_results(task:)
    end

    def value_for(**args)
      results.detect { |result| result.symbolize_keys >= args }&.dig('value')
    end

    def avg_for(**args)
      assesments = results.select { |result| result.symbolize_keys >= args }
      sum = assesments.map { |asm| asm['value'] }.sum
      (sum.to_f / assesments.count).round(2)
    rescue ZeroDivisionError
      0
    end

    def sum_for(**args)
      results
        .select { |result| result.symbolize_keys >= args }
        .group_by { |r| r['criteria_id'] }
        .map do |_criteria_id, values|
          sum = values.map { |asm| asm['value'] }.sum
          (sum.to_f / values.count).round(2)
        rescue ZeroDivisionError
          0
        end.sum
    end
  end
end
