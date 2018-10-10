require 'open-uri'

class DODService
  def get_article_list
    open('https://www.fbo.gov/index.php?s=opportunity&mode=list&tab=list&tabmode=list/')
  end

  def get_article_list_by_page(page)
    open("https://www.fbo.gov/index.php?s=opportunity&mode=list&tab=list&tabmode=list&pageID=#{page}")
  end

  def get_article(param)
    open("https://www.fbo.gov/index.php#{param}")
  end
end