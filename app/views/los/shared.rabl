object false

node(:total) {|m| @los.total_count }
node(:total_pages) {|m| @los.num_pages }

child @los do 
  attributes :id, :name, :description

  node(:created_by) { |lo| lo.user.name }

  node(:created_at) { |lo| l lo.created_at }
  node(:updated_at) { |lo| l lo.updated_at }

  node(:status) { |lo| lo.shared_status_for(current_user) }
end
