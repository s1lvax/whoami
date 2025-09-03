xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

xml.rss version: "2.0", "xmlns:content" => "http://purl.org/rss/1.0/modules/content/" do
  xml.channel do
    xml.title "#{@user.username} — Posts"
    xml.link  public_profile_url(username: @user.username)
    xml.description "All published posts by #{@user.username}"
    xml.language "en"
    xml.lastBuildDate (@posts.first&.published_at || Time.current).to_time.utc.rfc2822

    @posts.each do |post|
      link = public_post_url(username: @user.username, id: post)
      xml.item do
        xml.title post.title
        xml.link  link
        xml.guid  link, isPermaLink: true
        xml.pubDate (post.published_at || post.updated_at).to_time.utc.rfc2822
        summary = post.excerpt.presence || post.body.to_plain_text.to_s.truncate(280)
        xml.description CGI.escapeHTML(summary)
        xml.tag!("content:encoded", post.body.to_s)
      end
    end
  end
end
