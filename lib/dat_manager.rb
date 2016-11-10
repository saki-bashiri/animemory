class DatManager
  SUBJECT_FILE = "subject.txt"
  attr_reader :board

  def initialize(board_id)
    @board = Board.find_by_id(board_id)
    @host = host_2ch(@board)
  end

  def get_subjects
    @response = request(@host + SUBJECT_FILE)
    body = @response.body.toutf8
    subjects = body.split("\n").map{|res| res.split(".dat<>")}
    subject_hash = {}
    subjects.each do |subject_set|
      result = subject_set[1].match(/^(.*)\((\d+)\)$/)
      subject = result[1]
      count = result[2].to_i
      subject_hash[subject_set[0].to_i] = {:subject => subject, :count => count}
    end

    return subject_hash
  end

  def get_thread(dat_cd, since_at=nil)
    header = since_at.present? ? {'If-Modified-Since' => since_at, 'Accept-Encoding' => "identify"} : {}
    @response = request(@host + dat_file(dat_cd), header)
    body = @response.body.toutf8
    reses = body.split("\n").map{|res| res.split("<>")}
    results = []
    reses.each do |res|
      post_data = res[2].match(/^(\d+)\/(\d+)\/(\d+)\([月|火|水|木|金|土|日]\) (\d+):(\d+):(\d+)\.(\d+) ID:(.+)/)
      next if res.blank? || post_data.blank?
      name = res[0].gsub(/<.*>/, "")
      posted_at = Time.zone.local(post_data[1].to_i, post_data[2].to_i, post_data[3].to_i, post_data[4].to_i, post_data[5].to_i, post_data[6].to_i)
      post_cd = post_data[8].gsub(/<.*>/, "")
      content = res[3].gsub(/<a href=".*".*>&gt;&gt;(\d+)<\/a>/, ">>\\1").gsub(/<br>/, "\n")
      result = {:name => name, :content => content, :posted_at => posted_at, :post_cd => post_cd}
      results << result
    end
    results
  end

  private
  def host_2ch(board)
    "http://#{board.sub_domain}.2ch.net/#{board.dir}/"
  end

  def dat_file(dat_cd)
    "dat/#{dat_cd}.dat"
  end

  def request(url, header={})
    uri = URI(url)
    http = Net::HTTP.new(uri.host)
    response = http.get(uri.request_uri, header)
  end
end