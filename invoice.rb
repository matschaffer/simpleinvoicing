require 'rubygems'
require 'erb'
require 'ostruct'
require 'activesupport'
require 'action_controller'
require 'action_view'

class Invoice
  include ActionView::Helpers::TextHelper
  
  def initialize
    @items = []
    @unit = "$"
    @decimal_places = 2
    yield self
  end

  [:number, :from, :to, :unit, :decimal_places, :due_date].each do |attrib|
    eval %(
      def #{attrib}(value = nil)
        if value
          @#{attrib} = value
        else
          @#{attrib}
        end
      end
    )
  end

  attr_reader :items
  def item(*args)
    items << OpenStruct.new(args.last)
  end
  
  def total_quantity
    pluralize(items.map(&:quantity).sum, "hour")
  end
  
  def total_cost
    "%s%0.#{decimal_places}f" % [unit, items.map{ |i| i.rate * i.quantity }.sum]
  end
  
  def path_to(file)
    File.join(File.dirname(__FILE__), file)
  end
  
  def render
    filename = $0.gsub(/\.rb/, '')
    File.open("#{filename}.html", 'w+') do |f|
      f.print ERB.new(File.read(path_to('templates/invoice.html.erb'))).result(binding)
    end
  end
  
  def stylesheet(file)
    '<style type="text/css" media="screen, print">' + 
    File.read(path_to("templates/stylesheets/#{file}.css")) +
    '</style>'
  end
end