# encoding: utf-8
class Contract < ActiveRecord::Base
  belongs_to :manager
  belongs_to :car
  belongs_to :person
  has_many :proposals

  serialize :gifts

  def docx
    File.new Rails.root.join('assets', 'docx_template', 'docProps', 'custom.xml'), 'r'
  end

  def body
    file = File.new Rails.root.join('assets', 'docx_template', 'word', 'document.xml'), 'r'
    REXML::Document.new file.read
  end

  def properties
    REXML::Document.new File.new(Rails.root.join('assets', 'docx_template', 'docProps', 'custom.xml'), 'r').read
  end

  def footer1
    REXML::Document.new File.new(Rails.root.join('assets', 'docx_template', 'word', 'footer1.xml'), 'r').read
  end

  def footer2
    REXML::Document.new File.new(Rails.root.join('assets', 'docx_template', 'word', 'footer2.xml'), 'r').read
  end


  def attrs
    {
            :price => Object.new.extend(ActionView::Helpers::NumberHelper).number_to_currency(self.price, :unit => '', :separator => ',', :delimiter => " "),
            :price_w => RuPropisju.amount_in_words(self.price, :rur).split(/\ /)[0..-2].join(' ').mb_chars.capitalize.to_s,
            :number => number,
            :top_date => I18n.localize(Time.now, :format => '%d %B %Y г.'),
            :person_name => self.person.name,
            :car_model_name => self.car.model.name,
            :prepay => Object.new.extend(ActionView::Helpers::NumberHelper).number_to_currency(self.prepay, :unit => '', :separator => ',', :delimiter => " "),
            :prepay_w => RuPropisju.amount_in_words(self.prepay, :rur).split(/\ /)[0..-2].join(' ').mb_chars.capitalize.to_s,
            :s_name => self.person.short_name,
            :birthday => self.person.birthday.strftime('%d.%m.%Y г.'),
            :address => self.person.address,
            :p_id => "#{person.id_series.to_s.gsub(/(\d\d)(\d\d)/, '\1 \2')} #{person.id_number} #{person.id_dep}",
            :phones => self.person.phones.join(', '),
            :vin => self.car.vin,
            :color => self.car.color_id,
            :interior => self.car.interior_id,
            :production_year => self.car.prod_date.year,
            :gifts => self.gifts

    }
  end

  def prop

    doc = self.properties

    while doc.root.delete_element "//property"
      true
    end

    counter = 2

    docbody = self.body

    keys = attrs.keys

    for key in keys
      element = REXML::Element.new('property')
      element.add_attribute 'fmtid', '{D5CDD505-2E9C-101B-9397-08002B2CF9AE}'
      element.add_attribute 'pid', counter
      element.add_attribute 'name', key

      ne = REXML::Element.new 'vt:lpwstr'
      ne.add_text attrs[key].to_s || ' '

      element.add_element ne

      doc.root.add_element element
      Rails.logger.info key.inspect

      counter += 1
    end

    keys.delete :s_name
    keys.delete :gifts

    for key in keys
      docbody.root.elements["*/w:p/w:fldSimple[@w:instr=' DOCPROPERTY  #{key.to_s}  \\* MERGEFORMAT ']"].elements['w:r'].elements['w:t'].text = (attrs[key].to_s || ' ')
    end

    docbody.root.elements["*/w:p/w:fldSimple[@w:instr=' DOCPROPERTY  person_name_2  \\* MERGEFORMAT ']"].elements['w:r'].elements['w:t'].text = (attrs[:person_name].to_s || ' ')

    footer_1 = footer1
    footer_1.root.elements["//w:p/w:fldSimple[@w:instr=' DOCPROPERTY  s_name  \\* MERGEFORMAT ']"].elements['w:r'].elements['w:t'].text = (attrs[:s_name].to_s || ' ')

    footer_2 = footer2
    footer_2.root.elements["//w:p/w:fldSimple[@w:instr=' DOCPROPERTY  person_name  \\* MERGEFORMAT ']"].elements['w:r'].elements['w:t'].text = (attrs[:person_name].to_s || ' ')
    footer_2.root.elements["//w:p/w:fldSimple[@w:instr=' DOCPROPERTY  birthday  \\* MERGEFORMAT ']"].elements['w:r'].elements['w:t'].text = (attrs[:birthday].to_s || ' ')
    footer_2.root.elements["//w:p/w:fldSimple[@w:instr=' DOCPROPERTY  address  \\* MERGEFORMAT ']"].elements['w:r'].elements['w:t'].text = (attrs[:address].to_s || ' ')
    footer_2.root.elements["//w:p/w:fldSimple[@w:instr=' DOCPROPERTY  p_id  \\* MERGEFORMAT ']"].elements['w:r'].elements['w:t'].text = (attrs[:p_id].to_s || ' ')
    footer_2.root.elements["//w:p/w:fldSimple[@w:instr=' DOCPROPERTY  phones  \\* MERGEFORMAT ']"].elements['w:r'].elements['w:t'].text = (attrs[:phones].to_s || ' ')
    footer_2.root.elements["//w:p/w:fldSimple[@w:instr=' DOCPROPERTY  s_name  \\* MERGEFORMAT ']"].elements['w:r'].elements['w:t'].text = (attrs[:s_name].to_s || ' ')


    for code in self.car.codes
      unless code[1] == 'Опция неизвестна'
        count = docbody.root.elements[1].elements.count
        before = docbody.root.elements[1].elements[count]
        paragraph = REXML::Element.new('w:p')
        paragraph.add_attribute 'w:rsidR', '000D076D'
        paragraph.add_attribute 'w:rsidRDefault', '000D076D'
        paragraph.add_attribute 'w:rsidP', "00100AA3"
        paragraph.add_attribute 'w:rsidRPr', '00254ACB'

        wr = REXML::Element.new 'w:r'

        wsz = REXML::Element.new 'w:sz'
        wsz.add_attribute 'w:val', '20'

        wszCs = REXML::Element.new 'w:szCs'
        wszCs.add_attribute 'w:val', '20'

        wrPr = REXML::Element.new 'w:rPr'

        wt = REXML::Element.new 'w:t'
        wt.add_text code[1]

        wrfonts = REXML::Element.new 'w:rFonts'
        wrfonts.add_attribute 'w:ascii', 'CorporateS'
        wrfonts.add_attribute 'w:hAnsi', 'CorporateS'

        wrPr.add_element wrfonts
        wrPr.add_element wsz
        wrPr.add_element wszCs

        wr.add_element wrPr
        wr.add_element wt

        paragraph.add_element wr

        docbody.root.elements[1].insert_before before, paragraph
      end
    end

    self.gifts.each do |key, value|
      unless value.to_s == "0"
        count = docbody.root.elements[1].elements.count
        before = docbody.root.elements[1].elements[count]
        paragraph = REXML::Element.new('w:p')
        paragraph.add_attribute 'w:rsidR', '000D076D'
        paragraph.add_attribute 'w:rsidRDefault', '000D076D'
        paragraph.add_attribute 'w:rsidP', "000D076D"

        pPr = REXML::Element.new 'w:pPr'
        wr = REXML::Element.new 'w:r'

        wsz = REXML::Element.new 'w:sz'
        wsz.add_attribute 'w:val', '20'

        wszCs = REXML::Element.new 'w:szCs'
        wszCs.add_attribute 'w:val', '20'

        wrPr = REXML::Element.new 'w:rPr'

        wt = REXML::Element.new 'w:t'
        wt.add_text I18n.t("#{key}")


        wrPr.add_element wsz
        wrPr.add_element wszCs

        wr.add_element wrPr
        wr.add_element wt

        paragraph.add_element wr

        docbody.root.elements[1].insert_before before, paragraph
      end
    end

    temp = Rails.root.join 'tmp', Time.now.to_i.to_s

    Dir.mkdir temp

    source = Rails.root.join('assets', 'docx_template')

    system("cp -r #{source}/. #{temp}  ")
    system "rm Rails.root.join('tmp', temp, 'word', 'footer1.xml')"
    system "rm Rails.root.join('tmp', temp, 'word', 'footer2.xml')"

    file = File.new Rails.root.join('tmp', temp, 'docProps', 'custom.xml'), 'w'
    file.write doc.to_s
    file.close


    file = File.new Rails.root.join('tmp', temp, 'word', 'document.xml'), 'w'
    file.write docbody.to_s
    file.close

    file = File.new(Rails.root.join('tmp', temp, 'word', 'footer1.xml'), 'w')
    file.write footer_1.to_s
    file.close

    file = File.new(Rails.root.join('tmp', temp, 'word', 'footer2.xml'), 'w')
    file.write footer_2.to_s
    file.close

    system("cd #{temp} && zip -r contract.docx .")

    temp
  end


end
