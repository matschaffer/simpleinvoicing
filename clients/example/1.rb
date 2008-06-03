require '../../invoice.rb'

Invoice.new do |i|
  i.number '20080601-1'
  i.from "Me"
  i.to "You"
  i.item :date => '2006-01-01', :rate => 70, :quantity => 2, :description => 'thingie'
  i.item :date => '2006-01-01', :rate => 70, :quantity => 2, :description => 'thingie'
  i.due_date "2006-02-01"
end.render
