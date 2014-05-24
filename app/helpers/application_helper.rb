module ApplicationHelper
  def markdown(text)
    options = {:hard_wrap => true, :filter_html => true, :autolink => true,
               :no_intraemphasis => true, :fenced_code => true, :gh_blockcode => true}
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    markdown.render(text).html_safe
  end

  def user_belongs_to_control_group 
    control = [ "ale_diniz98@hotmail.com",
                "gustavogta20@hotmail.com",
                "lucasnunesme@gmail.com",
                "luisfelippeflores@gmail.com",
                "annacarazzai@hotmail.com",
                "re_nan_diego@hotmail.com",
                "hector.iniesta@hotmail.com",
                "andre.fernandes1997@hotmail.com",
                "lucas.andre12451@gmail.com",
                "matheus_martelotti@hotmail.com",
                "gregor.lohan@hotmail.com",
                "leonardo_cardosodossantos@hotmail.com",
                "nathaliapb2008@hotmail.com",
                "suellen_skc@hotmail.com",
                "jonathanlus@hotmail.com",
                "benjamim_fernando@hotmail.com",
                "marialuiza_g@hotmail.com",
                "saracristina.martins@hotmail.com",
                "kekinha-mara@hotmail.com",
                "lucastamarossi_@hotmail.com",
                "giovannibs2013@gmail.com",
                "mfkipper@hotmail.com",
                "yuri.soares98@hotmail.com",
                "camila_solivam@hotmail.com",
                "theus.topolski@gmail.com",
                "leonardo-santoss@outlook.com",
                "durval_gab@hotmail.com",
                "junior_phoda@live.com",
                "dvs.olie@hotmail.com;dvs.olie@hormail.com",
                "isa.bela_26@hotmail.com",
                "leonardockeller@gmail.com",
                "leonardo.simao@hotmail.com.br",
                "leonardovitornunes@hotmail.com",
                "viniciuspadilha_silva@hotmail.com",
    ]
    (current_user && control.include?(current_user.email))
  end
end
