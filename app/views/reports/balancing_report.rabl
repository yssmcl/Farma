collection @statistics, object_root: false

attributes :id, :name

node(:question) { |statistic| statistic[4] }
node(:exercises_correct_amount) { |statistic| statistic[1]}
node(:exercises_incorrect_amount) { |statistic| statistic[2]}
node(:exercises_answers) { |statistic| statistic[3]}
node(:difficult_degree) { |statistic| statistic[0] }
node(:index) { |statistic| @statistics.find_index(statistic)+1 }

