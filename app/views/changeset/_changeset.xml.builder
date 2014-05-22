xml.changeset(:id => changeset.id, :uid => changeset.user.id, :user => changeset.user.display_name, :created_at => changeset.created_at.xmlschema, :closed_at => changeset.closed_at, :open => changeset.is_open?, :min_lat => changeset.min_lat, :min_lon => changeset.min_lon, :max_lat => changeset.max_lat, :max_lon => changeset.max_lon) do
  changeset.tags.each do |k,v|
    xml.tag :k => k, :v => v
  end

  xml.comments do 
    changeset.comments.each do |comment|
      xml.comment do
        xml.date comment.created_at

        xml.uid comment.author.id
        xml.user comment.author.display_name
        xml.user_url user_url(:display_name => comment.author.display_name, :host => SERVER_URL)

        xml.text comment.body.to_text
        xml.html comment.body.to_html
      end
    end
  end
end

# TODO elf.user.data_public?, bbox bounds