object false

child(:lo) do
  node(:id)   { @lo.id}
  node(:name) { @lo.name}
end

child(@lo.contents => :contents) do
  node do |content|
    partial("lo_contents/content", object: content)
  end
end
