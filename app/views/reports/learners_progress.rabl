collection @learners, object_root: false

attributes :id, :name, :email

node(:completeness) { |learner| learner.completeness_of(@team, @lo)}
node(:exercises_correct_amount) { |learner| learner.exercises_correct_of(@team, @lo)}
node(:exercises_done_amount) { |learner| learner.exercises_done_of(@team, @lo)}
node(:index) { |learner| @learners.find_index(learner)+1 }
