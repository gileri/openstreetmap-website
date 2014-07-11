module RichText
  HASH_DIRECTIVES = {
    'c' => { :action => 'changeset', :nice_text => 'Changeset' },
    'o' => { :action => 'note', :nice_text => 'Note' },
    'w' => { :action => 'way', :nice_text => 'Way' },
    'r' => { :action => 'relation', :nice_text => 'Relation'},
    'n' => { :action => 'node', :nice_text => 'Node'}
  }
  def self.new(format, text)
    case format
    when "html"; HTML.new(text || "")
    when "markdown"; Markdown.new(text || "")
    when "text"; Text.new(text || "")
    else; nil
    end
  end

  class SimpleFormat
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::OutputSafetyHelper

    def sanitize(text)
      Sanitize.clean(text, Sanitize::Config::OSM).html_safe
    end
  end

  class Base < String
    include ActionView::Helpers::TagHelper
    include ActionDispatch::Routing
    include Rails.application.routes.url_helpers

    def spam_score
      link_count = 0
      link_size = 0

      doc = Nokogiri::HTML(to_html)

      if doc.content.length > 0
        doc.xpath("//a").each do |link|
          link_count += 1
          link_size += link.content.length
        end

        link_proportion = link_size.to_f / doc.content.length.to_f
      else
        link_proportion = 0
      end

      return [link_proportion - 0.2, 0.0].max * 200 + link_count * 40
    end

  protected

    def simple_format(text)
      SimpleFormat.new.simple_format(text)
    end

    def linkify(text)
      if text.html_safe?
        Rinku.auto_link(text, :urls, tag_options(:rel => "nofollow")).html_safe
      else
        Rinku.auto_link(text, :urls, tag_options(:rel => "nofollow"))
      end
    end

    def expand_links(text)
      result = text.gsub(/#(#{Regexp.union( HASH_DIRECTIVES.keys )})(\d+)/) do |match|
      from = match[1]
      num = match[2]
      options = HASH_DIRECTIVES[from]
      link_to("#{options[:nice_text]} ##{num}",url_for(:controller => 'browse', :action => options[:action],
          :id => num.to_i, :only_path => false, :host => SERVER_URL))
      end

      if text.html_safe?
        result.html_safe
      else
        result
      end
    end

    def expand_links_markdown(text)
      result = text.gsub(/#(#{Regexp.union( HASH_DIRECTIVES.keys )})(\d+)/) do |match|
        from = match[1]
        num = match[2]
        options = HASH_DIRECTIVES[from]
        "[#{options[:nice_text]} ##{num}](#{url_for(:controller => 'browse', :action => options[:action],
            :id => num.to_i, :only_path => false, :host => SERVER_URL)})"
      end

      if text.html_safe?
        result.html_safe
      else
        result
      end
    end
  end

  class HTML < Base
    def to_html
      linkify(expand_links(sanitize(simple_format(self))))
    end

    def to_text
      expand_links(self).to_s
    end

  private

    def sanitize(text)
      Sanitize.clean(text, Sanitize::Config::OSM).html_safe
    end
  end

  class Markdown < Base
    def to_html
      html_parser.render(expand_links_markdown(self)).html_safe
    end

    def to_text
      expand_links_markdown(self).to_s
    end

  private

    def html_parser
      @@html_renderer ||= Renderer.new({
        :filter_html => true, :safe_links_only => true
      })
      @@html_parser ||= Redcarpet::Markdown.new(@@html_renderer, {
        :no_intra_emphasis => true, :autolink => true, :space_after_headers => true
      })
    end

    class Renderer < Redcarpet::Render::XHTML
      def link(link, title, alt_text)
        "<a rel=\"nofollow\" href=\"#{link}\">#{alt_text}</a>"
      end

      def autolink(link, link_type)
        if link_type == :email
          "<a rel=\"nofollow\" href=\"mailto:#{link}\">#{link}</a>"
        else
          "<a rel=\"nofollow\" href=\"#{link}\">#{link}</a>"
        end
      end 
    end
  end

  class Text < Base
    def to_html
      linkify(expand_links(simple_format(ERB::Util.html_escape(self))))
    end

    def to_text
      expand_links(self).to_s
    end
  end
end
