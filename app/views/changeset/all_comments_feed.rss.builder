xml.rss("version" => "2.0", 
        "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title t('changeset.rss.title_all')
    xml.link url_for(:controller => "site", :action => "index", :only_path => false)

    xml << render(:partial => "comments", :object => @comments)
  end
end