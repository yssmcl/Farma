object false
result = []

@teams.each do |team|
  team.los.each do |lo|
    result << {
      id: lo.id,
      name: lo.name,
      completeness: current_user.completeness_of(team, lo),
      team: {
        id: team.id,
        name: team.name
      }
    }
  end
end

return result.to_json
