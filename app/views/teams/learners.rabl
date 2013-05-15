collection @learners, object_root: false

attributes :id

#node(:label) {|t| t.name}
#node(:value) {|t| t.name}
node(:label) {|t| t.name + " | " + t.email}
node(:value) {|t| t.name + " | " + t.email}
