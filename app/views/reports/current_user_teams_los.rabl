object false
result = []

@teams.each do |team|
  team.los.each do |lo|
    result << {
      id: lo.id,
      name: lo.name,
      completeness: current_user.completeness_of(team, lo),
      exercises_correct_amount: current_user.exercises_correct_of(team, lo),
      exercises_done_amount: current_user.exercises_done_of(team, lo),
      team: {
        id: team.id,
        name: team.name
      }
    }
  end
end

return result.to_json
