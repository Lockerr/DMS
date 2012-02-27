# encoding: utf-8
require 'spreadsheet'

def clear(value)
  value.gsub!(/(Blue)(EFFICIENCY)/, '')
  value.gsub!(/(Особая серия)/, 'OC')
  value.gsub!(/(Внедорожник)/, '')
  value.gsub!(/(Седан)/, '')
  value.gsub!(/(Особая)/, 'ОС')
  value.gsub!(/(\(длинная база\))/, '')
  value.gsub!(/(Mercedes\-Benz)/, '')
  value.gsub!(/(\t)/, ' ')
  value.gsub!(/(\s)/, ' ')
  value.gsub!(/(\ \ )/, ' ')
  value.gsub!(/(\s\s)/, ' ')
  value.gsub!(/(^\s)/, '')
  value.gsub!(/(\w)(\d\d\d)/, '\1 \2')
  value


end

book = Spreadsheet.open 'tmp/export.xls'
for ws in book.worksheets
  ws.each do |row|
    unless row[0] == 'Дата продажи а/м дилеру'
      #puts '++++++++++++++++++'
      #puts row[0]
      #puts '========='
      puts clear(row[30])
      #puts "#{row[2]}\t#{row[3]}\t#{clear(row[30])}\t#{row[31]} #{row[32]} #{row[39]} #{row[41]}"
      #if row[34]
      #  opts = row[33].split('.') + row[34].split('.')
      #
      #else
      #  opts = row[33].split('.')
      #
      #end
      #puts opts.inspect
    end
  end
end
