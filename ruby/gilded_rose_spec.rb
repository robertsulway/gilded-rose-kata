require File.join(File.dirname(__FILE__), 'gilded_rose')
require File.join(File.dirname(__FILE__), 'texttest_fixture')

describe GildedRose do

DAYS = 5


  describe "#update_quality" do

    it "does not change the name" do
      items = [Item.new("name1", 0, 0)]
      GildedRose.new(items).update_quality()
      items[0].name.should == "name1"
    end

    it "Once the sell by date has passed, quality degrades twice as fast" do
      test_items = item_list_gen.reject{|item| ["Backstage passes to a TAFKAL80ETC concert"].include? item.name }
      gilded_rose = GildedRose.new(test_items)
      h = {}
      test_items.each{|i| h[i] = {i.sell_in => i.quality}} #hash in which each 'item' points to a hash that tells you what the quality was for each 'sell_in' value
      (0..DAYS).each do |day|

        #puts "day = #{day}"
        gilded_rose.update_quality
        test_items.each do |item|
#          puts item
#puts h
          h[item][item.sell_in] = item.quality#, (item.quality-h[item][item.sell_in + 1][0])]
          if h[item][1] && h[item][0] && h[item][-1] #if we have both a positive and negative 'sell_in' value for the item, so the test makes sense
#puts item
            ((h[item][0]-h[item][1])*2).should == (h[item][-1]-h[item][0])
          end
        end
        #puts "-----"
        #puts @test_items
      end
    end

    it "quality is never negative" do
      test_items_2 = item_list_gen
      gilded_rose = GildedRose.new(test_items_2)
      (0..DAYS).each do |day|
        #puts "day = #{day}"
        gilded_rose.update_quality
        test_items_2.each{|item| item.quality.should >= 0}
        #puts "-----"
        #puts @test_items
      end
    end

    it "The quality of an item is never more than 50" do
      test_items = item_list_gen.reject{|item| ["Sulfuras, Hand of Ragnaros"].include? item.name }
      gilded_rose = GildedRose.new(test_items)
      (0..DAYS).each do |day|
        #puts "day = #{day}"
        gilded_rose.update_quality
        test_items.each{|item| item.quality.should <= 50}
        #puts "-----"
        #puts @test_items
      end
    end

    it "Aged Brie increases in quality the older it gets" do
      test_items = item_list_gen
      gilded_rose = GildedRose.new(test_items)
      brie = test_items.select{|item| item.name == "Aged Brie"}[0]
      #qualities_history = [brie.quality]
      (0..DAYS).each do |day|
        #puts "day = #{day}"
        previous_quality = brie.quality
        gilded_rose.update_quality
        brie.quality.should > previous_quality
        #qualities_history.append(brie.quality)
        #puts "-----"
        #puts @test_items
      end
      #qualities_history.each{|quality| }
    end

    it "Sulfuras never has to be sold or decreases in quality" do
      test_items = item_list_gen
      gilded_rose = GildedRose.new(test_items)
      sulfuras = test_items.select{|item| item.name == "Sulfuras, Hand of Ragnaros"}[0]
      (0..DAYS).each do |day|
        #puts "day = #{day}"
        previous_quality = sulfuras.quality
        gilded_rose.update_quality
        sulfuras.quality.should == previous_quality
        sulfuras.sell_in.should >= 0
        #puts "-----"
        #puts @test_items
      end
    end

    it "Backstage Passes" do
      test_items = item_list_gen

      gilded_rose = GildedRose.new(test_items)
      bps = [test_items.select{|item| item.name == "Backstage passes to a TAFKAL80ETC concert"}[0]]
  #    puts bps
      (0..10).each do |day|
        #puts "day = #{day}"

        bps.each do |bp|
          test_gr = GildedRose.new([bp])
          previous_quality = bp.quality
#          puts bp
          test_gr.update_quality
          quality = bp.quality
          sell_in = bp.sell_in
          if sell_in > 10
            (quality - previous_quality).should == 1
          elsif sell_in <=10 && sell_in >5

  #          puts "here"
#            puts bp

            (quality - previous_quality).should == 2
          elsif sell_in <= 5 && sell_in >=0
            (quality - previous_quality).should == 3
          elsif sell_in < 0
            quality.should == 0
          end
        end

        #puts "-----"
        #puts @test_items
      end
    end

    it "Conjured items degrade in quality twice as fast" do
      test_items = item_list_gen
      gilded_rose = GildedRose.new(test_items)
      conjured = test_items.select{|item| item.name == "Conjured Mana Cake"}[0]
      (0..DAYS).each do |day|
        #puts "day = #{day}"
        previous_quality = conjured.quality
        gilded_rose.update_quality
        if conjured.sell_in > 0
            (conjured.quality-previous_quality).should == -2

        end
        #puts "-----"
        #puts @test_items
      end
    end

  end

end
