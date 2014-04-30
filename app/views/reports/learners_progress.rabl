collection @learners, object_root: false

attributes :id, :name, :email

node(:completeness) { |learner| learner.completeness_of(@team, @lo)}
node(:index) { |learner| @learners.find_index(learner)+1 }
