object false

child @los do
  attributes :id, :name
end

child @learners => :learners do
  attributes :id
  node(:name) {|learner| "#{learner.name} - #{learner.email}"}
end
