collection @exercises, object_root: false

attributes :id, :title, :subtopic, :content, :available, :introduction_ids

child(:questions) do
  attributes :id, :title, :content, :available
end

# child(:introductions) do
#   attributes :id, :title
# end

node(:created_at) { |exer| l exer.created_at }
node(:updated_at) { |exer| l exer.updated_at }
