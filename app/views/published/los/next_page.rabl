glue @lo do
  attributes :id, :name, :content
end

node(:pages_count) { @sequence.pages_count }
node(:pages) { @sequence.pages_with_name }

node :contents do
  @sequence.pages.map do |page|
    result = {}
    result['id'] = page.id
    result['title'] = page.title
    result['content'] = page.content
    result['type'] = page.class.name
    if page.is_a?(Exercise)
      result['questions'] = partial("published/los/questions", :object => page.questions_avaiable)
    end
    result
  end
end
