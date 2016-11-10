module MasterTable
  module RssSite
    SITE_KEYS = [:magsoku, :otanews, :himarin, :yaraon, :otanew, :anisoku_matome, :matomate, :otakomu,
                 :nandaka_omoshiroi, :itsoku, :seiyuusokuhou, :seiyufan]
    NAME = {
      :magsoku           => "MAG速",
      :otanews           => "萌えオタクニュース速報",
      :himarin           => "ひまねっと",
      :yaraon            => "やらおん",
      :otanew            => "オタクニュース",
      :anisoku_matome    => "アニ速まとめ",
      :matomate          => "まとめいと",
      :otakomu           => "オタク.com",
      :nandaka_omoshiroi => "なんだかおもしろい",
      :itsoku            => "IT速報",
      :seiyuusokuhou     => "声優☆速報",
      :seiyufan          => "seiyu fan"
    }

    URL = {
      :magsoku           => "http://magsoku.blomaga.jp/",
      :otanews           => "http://otanews.livedoor.biz/",
      :himarin           => "http://himarin.net/",
      :yaraon            => "http://yaraon.blog109.fc2.com/",
      :otanew            => "http://otanew.jp/",
      :anisoku_matome    => "http://blog.livedoor.jp/ani_soku_matome/",
      :matomate          => "http://matomate.blog133.fc2.com/",
      :otakomu           => "http://otakomu.jp/",
      :nandaka_omoshiroi => "http://zakuzaku911.com/",
      :itsoku            => "http://blog.livedoor.jp/itsoku/",
      :seiyuusokuhou     => "http://seiyuusokuhou.blog106.fc2.com/",
      :seiyufan          => "http://seiyufan.livedoor.biz/"
    }

    RSS_URL = {
      :magsoku           => "http://magsoku.blomaga.jp/index.rdf",
      :otanews           => "http://otanews.livedoor.biz/index.rdf",
      :himarin           => "http://himarin.net/index.rdf",
      :yaraon            => "http://yaraon.blog109.fc2.com/?xml",
      :otanew            => "http://otanew.jp/index.rdf",
      :anisoku_matome    => "http://anisoku-matome.dreamlog.jp/index.rdf",
      :matomate          => "http://matomate.blog133.fc2.com/?xml",
      :otakomu           => "http://otakomu.jp/feed/rdf",
      :nandaka_omoshiroi => "http://zakuzaku911.com/index.rdf",
      :itsoku            => "http://blog.livedoor.jp/itsoku/index.rdf",
      :seiyuusokuhou     => "http://seiyuusokuhou.blog106.fc2.com/?xml",
      :seiyufan          => "http://seiyufan.livedoor.biz/index.rdf"
    }

    class << self
      def type_num(key)
        SITE_KEYS.index(key)
      end

      def site_name(key)
        NAME[key]
      end

      def type_to_sym(num)
        SITE_KEYS[num]
      end
    end
  end
end