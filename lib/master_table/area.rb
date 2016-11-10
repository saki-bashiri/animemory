module MasterTable
  module Area
    HOKKAIDO = 1
    TOHOKU   = 2
    KANTO    = 3
    CHUBU    = 4
    TOKAI    = 5
    KINKI    = 6
    CHUGOKU  = 7
    KYUSHU   = 8
    TOKYO    = 9
    SAITAMA  = 10
    CHIBA    = 11
    KANAGAWA = 12
    JAPAN    = 0

    KEYS = [:japan, :hokkaido, :tohoku, :kanto, :chubu, :tokai, :kinki, :chugoku,
            :kyushu, :tokyo, :saitama, :chiba, :kanagawa]

    NAME = {
      :hokkaido => "北海道",
      :tohoku   => "東北",
      :kanto    => "関東",
      :chubu    => "中部",
      :tokai    => "東海",
      :kinki    => "近畿",
      :chugoku  => "中国",
      :kyushu   => "九州",
      :tokyo    => "東京",
      :saitama  => "埼玉",
      :chiba    => "千葉",
      :kanagawa => "神奈川",
      :japan    => "全国"
    }
    class << self
      def area_to_sym(num)
        KEYS[num] || :japan
      end

      def area_num(key)
        KEYS.index(key) || 0
      end

      def area_syms
        KEYS
      end

      def area_name(area)
        sym = area.is_a?(Symbol) ? area : area_to_sym(area.to_i)
        NAME[sym]
      end
    end
  end
end