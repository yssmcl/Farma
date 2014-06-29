#encoding: utf-8
attributes :id, :title, :content, :available, :position

child(:lo) do
  attributes :id, :name
end

node(:instance) { |ob| ob.class.to_s }
node(:created_at) { |ob| l ob.created_at }
node(:updated_at) { |ob| l ob.updated_at }

if @object.is_a?(Introduction)
  node(:type) { "Introdução" }
elsif @object.is_a?(Exercise)
  node(:type) { "Exercício" }
end

node(:number) { |ob| ob.number }
