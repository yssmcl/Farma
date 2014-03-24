#encoding: utf-8
object false

node(:total) {|m| @answers.total_count }
node(:total_pages) {|m| @answers.num_pages }

child @answers => :answers do
  extends("answers/attributes")
  node(:user_name) { "Não identificado" }
  node(:user_email) { "Não identificado" }
end
