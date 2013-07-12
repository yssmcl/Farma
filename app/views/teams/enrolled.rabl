collection @teams, object_root: false

attributes :id, :name

node(:label) {|t| t.name}
node(:value) {|t| t.name}

node(:numbers_of_enrolled) { |team| team.users.count }

child(:los) do
  attributes :id, :name, :description, :team_id
  node(:created_at) { |lo| l lo.created_at }
  node(:created_by) { |lo| lo.user.name }
end
