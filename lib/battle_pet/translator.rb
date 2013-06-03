# encoding: utf-8
class BattlePet::Translator

  def initialize(locale)
    @locale = locale
  end

  def colon
    case @locale
    when :cn then '：'
    when :tw then ':'
    else ': '
    end
  end

  def cost
    case @locale
    when :us, :eu then 'Cost'
    when :cn then '价格'
    when :tw then '花費'
    when :kr then '비용'
    end
  end
end
