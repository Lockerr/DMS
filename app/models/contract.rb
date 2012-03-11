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

  def attrs
    {
            :price => self.price,
            :price_w => RuPropisju.amount_in_words(self.price, :rur),
            :number => Time.now.year.to_s[2..3] + '/' + self.car.order.to_s[7..10],
            :top_date => I18n.localize(Time.now, :format => '%d %B %Y г.'),
            :person_name => self.person.name,
            :car_model_name => self.car.model.name,
            :prepay => self.prepay,
            :prepay_w => RuPropisju.amount_in_words(self.prepay, :rur),
            :s_name => self.person.short_name,
            :birthday => self.person.birthday,
            :address => self.person.address,
            :p_id => (self.person.id_series || '').to_s + ' ' + (self.person.id_number || '').to_s + ' ' + (self.person.id_dep.to_s || '').to_s,
            :phones => self.person.phones,
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

    #attrs = self.attrs

    for key in attrs.keys
      element = REXML::Element.new('property')
      element.add_attribute 'fmtid', '{D5CDD505-2E9C-101B-9397-08002B2CF9AE}'
      element.add_attribute 'pid', counter
      element.add_attribute 'name', key

      ne = REXML::Element.new 'vt:lpwstr'
      ne.add_text attrs[key].to_s || ' '

      element.add_element ne

      doc.root.add_element element

      counter += 1
    end

    docbody = self.body
    for code in self.car.codes
      unless code[1] == 'Опция неизвестна'
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
        wt.add_text code[1]

        wrPr.add_element wsz
        wrPr.add_element wszCs

        wr.add_element wrPr
        wr.add_element wt

        paragraph.add_element wr

        docbody.root.elements[1].insert_before before, paragraph
      end
    end

    self.gifts.each do |key,value|
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

    file = File.new Rails.root.join('tmp', temp, 'docProps', 'custom.xml'), 'w'
    file.write doc.to_s
    file.close

    file = File.new Rails.root.join('tmp', temp, 'word', 'document.xml'), 'w'
    file.write docbody.to_s
    file.close

    system("cd #{temp} && zip -r contract.docx .")

    temp
  end


end
