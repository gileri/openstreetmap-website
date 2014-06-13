xml.rss("version" => "2.0", 
        "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title t('changeset.rss.title')
    xml.link url_for(:controller => "site", :action => "index", :only_path => false)

    @comments.each do |comment|

      xml.item do
        xml.title t("changeset.rss.comment")
        
        xml.link url_for(:controller => "browse", :action => "changeset", :id => comment.changeset.id, :anchor => "c#{comment.id}", :only_path => false)
        xml.guid url_for(:controller => "browse", :action => "changeset", :id => comment.changeset.id, :anchor => "c#{comment.id}", :only_path => false)

        xml.description do
          xml.cdata! render(:partial => "comments_entry", :object => comment, :formats => [ :html ])
        end

        if comment.author
          xml.dc :creator, comment.author.display_name
        end

        xml.pubDate comment.created_at.to_s(:rfc822)
      end
    end
  end
end