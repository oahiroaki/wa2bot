module Wa2Bot
  class Character
    attr_accessor :firstname, :lastname, :fullname, :icon

    # キャラクターの設定
    CHAR_DEFINISION = [
      {
        name: ['飯塚', '武也'],
        regexp: /武也|たけや/,
      },
      {
        name: ['和泉', '千晶'], # 名字、名前
        regexp: /千晶|ちあき/, # 名前の表記ブレ用正規表現
        icon: 'img/wa2_twicon04.png' # アイコン画像のパス
      },
      {
        name: ['小木曽', '雪菜'],
        regexp: /雪菜|せつな/,
        icon: 'img/wa2_twicon01.png'
      },
      {
        name: ['風岡', '麻理'],
        regexp: /麻理|まり/,
        icon: 'img/wa2_twicon05.png'
      },
      {
        name: ['杉浦', '小春'],
        regexp: /小春|こはる/,
        icon: 'img/wa2_twicon03.png'
      },
      {
        name: ['北原', '春希'],
        regexp: /春希|はるき/
      },
      {
        name: ['冬馬', 'かずさ'],
        regexp: /かずさ/,
        icon: 'img/wa2_twicon02.png'
      },
      {
        name: ['冬馬', '曜子'],
        regexp: /曜子|ようこ/
      },
      {
        name: ['柳原', '朋'],
        regexp: /朋|とも/
      },
      {
        name: ['水沢', '依緖'],
        regexp: /依緖|いお/
      }
    ]

    def initialize(src)
      begin
        parse_name(src)
      rescue => err
        # Undefined character
        @firstname = ''
        @lastname = ''
        @fullname = src
        @icon = 'img/180x180_2s.jpg'
      end
    end

    def parse_name(src)
      CHAR_DEFINISION.each do |obj|
        if src =~ obj[:regexp]
          @firstname = obj[:name].first
          @lastname = obj[:name].last
          @fullname = obj[:name].first + obj[:name].last
          @icon = (obj.include? :icon) ? obj[:icon] : 'img/180x180_2s.jpg'
          return
        end
      end
      raise "Not known character"
    end
  end
end
