class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    items = @items.dup
    items.each do |item|

      if !item.is_legendary
        item.sell_in = item.sell_in - 1
      end

      if item.is_normal
        item.quality = [0, item.quality - item.quality_scale_factor ].max
      end

      if item.is_brie || item.is_bp
        item.quality = [50, item.quality + item.quality_scale_factor].min
      end

      if item.is_bp
        if item.sell_in < 11
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
        if item.sell_in < 6
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
        if item.sell_in < 0
          item.quality = 0
        end
      end

    end
  end

end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end

  def is_brie
    @name == "Aged Brie"
  end

  def is_legendary
    @name == "Sulfuras, Hand of Ragnaros"
  end

  def is_bp
    @name == "Backstage passes to a TAFKAL80ETC concert"
  end

  def is_conjured
    @name == "Conjured Mana Cake"
  end

  def is_normal
    !self.is_brie && !self.is_legendary && !self.is_bp
  end

  def quality_scale_factor
    if !self.is_conjured
      self.sell_in < 0 ? 2 : 1
    else
      self.sell_in < 0 ? 4 : 2
    end
  end

end
