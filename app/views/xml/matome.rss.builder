xml.instruct!
xml.rdf:RDF, "version"    => '2.0',                              "xmlns:dc"   => "http://purl.org/dc/elements/1.1/",
              "xmlns:atom" => "http://www.w3.org/2005/Atom", "xmlns"       => "http://purl.org/rss/1.0/",
              "xml:lang" => "ja",
              "xmlns:rdf" => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
              "xmlns:content" => "http://purl.org/rss/1.0/modules/content/",
              "xmlns:taxo" => "http://purl.org/rss/1.0/modules/taxonomy/",
              "xmlns:syn" => "http://purl.org/rss/1.0/modules/syndication/",
              "xmlns:admin" => "http://webns.net/mvcb/",
              "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel("rdf:sbout" => create_url(:controller => "xml", :action => "matome", :format => "rss", :only_path => false)) do
    xml.title 'アニメモリ'
    xml.link root_url
    xml.description 'アニメのまとめを配信します。'
    xml.language "ja"
    xml.items do
      xml.rdf:Seq do
        @summaries.each do |summary|
          xml.rdf:li, "rdf:resource" => create_url({:controller => "summary", :action => "index", :sid => summary.id, :aid => summary.anime_id}, :full_path => true)
        end
      end
    end
  end
  @summaries.each do |summary|
    url = create_url({:controller => "summary", :action => "index", :sid => summary.id, :aid => summary.anime_id}, :full_path => true)
    title = "#{summary.title} [#{anime_with_episode(summary.anime, summary.episode)}]"
    xml.item("rdf:about" => url) do
      xml.link url
      xml.title title
      xml.description ""
      xml.content :encoded, ""
      xml.dc :subject, "アニメ感想"
      xml.dc :date, summary.created_at.strftime("%Y-%m-%dT%H:%M:%S%z")
      xml.dc :creator, "アニメモリ"
      xml.dc :publisher, "アニメモリ"
    end
  end
end