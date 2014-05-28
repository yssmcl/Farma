object @team

attributes :id, :name, :lo_ids

child :los do
  attributes :id, :name
end
