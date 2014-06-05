namespace :sequence do

  desc "Generate a copy of a LO with new sequencing"
  task :generate_new_lo => :environment do
    lo_id = "51a018ab759b7491ef00003d"   # OA Pitágoras Max - Senai - Curitiba/PR
    team_id = "51b9eef3759b74dcc20000c5" # Turma Pitágoras Max - Senai

    lo = Lo.find(lo_id)
    to_user = lo.user

    ## Clone Lo
    lo_cloned = DeepCloneLo.clone(lo, to_user)
    
    ## Calculates Statistic
    statistic = Sequence::Statistic.find_or_create_by(lo_id: lo_id,
                                                      team_id: team_id)
    #statistic.calculate_statistics

    new_order = statistic.order_exercises.map do |key, value| 
      [key, value["actual_position"]]
    end
    new_order.sort! { |a,b| a[1] <=> b[1]} # ordena pela actual_position

    new_order.map! do |a|
      exer = Exercise.find(a[0])
      or_index = lo.page_of(exer)
      lc = lo_cloned.content_at(or_index)
      lc.id.to_s
    end

    # Update Lo
    # contents retorna as introduções e exercícios na ordem definada pelo professor
    group = {}
    introductions = []
    lo_cloned.contents.each_with_index do |content, index|
      if content.is_a?(Introduction)
        introductions << content.id
      else
        group[content.id.to_s] = introductions
        introductions = []
      end
    end

    # atualiza posição
    position = 0
    new_order.each do |exer_id|
      group[exer_id].each_with_index do |intro_id|
        intro = Introduction.find(intro_id)
        intro.update_attribute(:position, position)
        position += 1
      end
      exer = Exercise.find(exer_id)
      exer.update_attribute(:position, position)
      position += 1
    end

  end
end
