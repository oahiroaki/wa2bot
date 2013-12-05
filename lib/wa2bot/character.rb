module Wa2Bot
  class Character
    attr_accessor :firstname, :lastname, :fullname, :icon

    ICONS = {
      # icons is not for a specific character
      defalut: [
        'img/180x180_2s.jpg',
        'img/WA2_twin_1.png',
        'img/WA2_sonota_1.png',
        'img/WA2_sonota_2.png',
        'img/WA2_sonota_3.png',
        'img/WA2_sonota_4.png'
      ],
      # setsuna's icons
      setsuna: [
        'img/wa2_twicon01.png',
        'img/WA2_setsuna_1.png',
        'img/WA2_setsuna_2.png',
        'img/WA2_setsuna_3.png',
        'img/WA2_setsuna_4.png',
        'img/WA2_setsuna_5.png',
        'img/WA2_SD_3.png',
        'img/WA2_SD_4.png'
      ],
      # kazusa's icons
      kazusa: [
        'img/wa2_twicon02.png',
        'img/WA2_kazusa_1.png',
        'img/WA2_kazusa_2.png',
        'img/WA2_kazusa_3.png',
        'img/WA2_kazusa_4.png',
        'img/WA2_kazusa_5.png',
        'img/WA2_SD_1.png',
        'img/WA2_SD_2.png'
      ],
      # koharu's icons
      koharu: [
        'img/wa2_twicon03.png',
      ],
      # chiaki's icons
      chiaki: [
        'img/wa2_twicon04.png',
      ],
      # mari's icons
      mari: [
        'img/wa2_twicon05.png',
      ],
      # haruki's icons
      haruki: [
        'img/haruki.png',
        'img/WA2_haruki_1.png',
        'img/WA2_haruki_2.png',
        'img/WA2_haruki_3.png'
      ],
      # takeya's icons
      takeya: [
        'img/WA2_takeya_1.png',
        'img/WA2_takeya_2.png',
        'img/WA2_takeya_3.png'
      ],
      # io's icons
      io: [
        'img/WA2_io_1.png',
        'img/WA2_io_2.png',
        'img/WA2_io_3.png'
      ]
    }

    # Character setting
    CHAR_DEFINISION = [
      {
        name: ['飯塚', '武也'],
        regexp: /武也|たけや/,
        icon: :takeya
      },
      {
        name: ['和泉', '千晶'],
        regexp: /千晶|ちあき/,
        icon: :chiaki
      },
      {
        name: ['小木曽', '雪菜'],
        regexp: /雪菜|せつな/,
        icon: :setsuna
      },
      {
        name: ['風岡', '麻理'],
        regexp: /麻理|まり/,
        icon: :mari
      },
      {
        name: ['杉浦', '小春'],
        regexp: /小春|こはる/,
        icon: :koharu
      },
      {
        name: ['北原', '春希'],
        regexp: /春希|はるき/,
        icon: :haruki
      },
      {
        name: ['冬馬', 'かずさ'],
        regexp: /かずさ/,
        icon: :kazusa
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
        regexp: /依緖|いお/,
        icon: :io
      }
    ]

    def initialize(src)
      CHAR_DEFINISION.each do |obj|
        if src =~ obj[:regexp]
          @firstname = obj[:name].first
          @lastname = obj[:name].last
          @fullname = obj[:name].first + obj[:name].last
          if obj.include? :icon
            @icon =ICONS[obj[:icon]].sample
          else
            @icon = ICONS[:defalut].sample
          end
          return
        end
      end
      # Undefined character
      @firstname = src
      @lastname = src
      @fullname = src
      @icon = ICONS[:defalut].sample
    end
  end
end
