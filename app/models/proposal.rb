#encoding: utf-8
class Proposal < ActiveRecord::Base
  belongs_to :manager
  belongs_to :car
  belongs_to :person
  belongs_to :contract

  def properties
    REXML::Document.new File.new(Rails.root.join('assets', 'proposal_template', 'docProps', 'custom.xml'), 'r').read
  end

  def body
    file = File.new Rails.root.join('assets', 'proposal_template', 'word', 'document.xml'), 'r'
    REXML::Document.new file.read
  end

  def header
    REXML::Document.new File.new(Rails.root.join('assets', 'proposal_template', 'word', 'header2.xml'), 'r').read
  end



  def attrs
    {
            :car_price => Object.new.extend(ActionView::Helpers::NumberHelper).number_to_currency(self.price, :unit => '', :separator => ',', :delimiter => " "),
            :person_name => self.person.name.split(' ')[1..2].join(' '),
            :car_model_name => self.car.model.name,
            :car_color_id => self.car.color_id,
            :car_interior_id => self.car.interior_id,
            :car_prod_year => self.car.prod_date.year,
            :manager_name => self.manager.name.split(' ')[0..1].join(' '),
            :car_klasse => self.car.klasse.name,
            :manager_email => self.manager.email,
            :manager_mobile => self.manager.mobile,
            :car_special_price => Object.new.extend(ActionView::Helpers::NumberHelper).number_to_currency(self.special_price, :unit => '', :separator => ',', :delimiter => " ")



    }
  end


  def prop
    doc = self.properties

    while doc.root.delete_element "//property"
      true
    end

    counter = 2

    #attrs = self.attrs
    docbody = self.body

    keys = self.attrs.keys

    for key in keys
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

    keys.delete :manager_mobile
    keys.delete :manager_name
    keys.delete :manager_email

    for key in keys
      Rails.logger.info key.inspect

        docbody.root.elements["*/w:p/w:fldSimple[@w:instr=' DOCPROPERTY  #{key.to_s}  \\* MERGEFORMAT ']"].elements['w:r'].elements['w:t'].text = (attrs[key].to_s || ' ')
    end
    header_1 = header
    header_1.root.elements["//w:p/w:fldSimple[@w:instr=' DOCPROPERTY  manager_mobile  \\* MERGEFORMAT ']"].elements['w:r'].elements['w:t'].text = (attrs[:manager_mobile].to_s || ' ')
    header_1.root.elements["//w:p/w:fldSimple[@w:instr=' DOCPROPERTY  manager_name  \\* MERGEFORMAT ']"].elements['w:r'].elements['w:t'].text = (attrs[:manager_name].to_s || ' ')
    header_1.root.elements["//w:p/w:fldSimple[@w:instr=' DOCPROPERTY  manager_email  \\* MERGEFORMAT ']"].elements['w:r'].elements['w:t'].text = (attrs[:manager_email].to_s || ' ')


    for code in self.car.codes
      unless code[1] == 'Опция неизвестна'
        count = docbody.root.elements[1].elements.count

        before = docbody.root.elements["*/w:p/w:bookmarkStart[@w:id='0']"].parent
        paragraph = REXML::Element.new('w:p')
        paragraph.add_attribute 'w:rsidR', '00D71A90'
        paragraph.add_attribute 'w:rsidRDefault', '00D71A90'
        paragraph.add_attribute 'w:rsidP', "00D71A90"
        paragraph.add_attribute 'w:rsidRPr', '00D71A90'



        pPr = REXML::Element.new 'w:pPr'



        # lvl 1 creating w:pStyle element of w:pPr
        wpstyle = REXML::Element.new 'w:pStyle'
        wpstyle.add_attribute 'w:val','ae'

        wnumpr = REXML::Element.new 'w:numPr'

        ilvl = REXML::Element.new 'w:ilvl'
        ilvl.add_attribute 'w:val','0'

        numid = REXML::Element.new 'w:numId'
        numid.add_attribute 'w:val','18'

        wnumpr.add_element ilvl
        wnumpr.add_element numid

        pPr.add_element wpstyle
        pPr.add_element wnumpr

        wrfonts = REXML::Element.new 'w:rFonts'
        wrfonts.add_attribute 'w:ascii', 'CorporateS'
        wrfonts.add_attribute 'w:hAnsi', 'CorporateS'

        wsz = REXML::Element.new 'w:sz'
        wsz.add_attribute 'w:val', '22'

        wszCs = REXML::Element.new 'w:szCs'
        wszCs.add_attribute 'w:val', '22'
        wlang = REXML::Element.new 'w:lang'
        wlang.add_attribute 'w:val', 'ru-RU'

        wrPr = REXML::Element.new 'w:rPr'
        wrPr.add_element wrfonts
        wrPr.add_element REXML::Element.new 'w:noProof'
        wrPr.add_element wsz
        wrPr.add_element wszCs
        wrPr.add_element wlang

        pPr.add_element wrPr

        paragraph.add_element pPr

        wt = REXML::Element.new 'w:t'
        wt.add_text code[1]

        wr = REXML::Element.new 'w:r'
        wr.add_attribute 'w:rsidRPr', '00D71A90'
        wr.add_element wrPr

        wr.add_element wt

        paragraph.add_element wr

        docbody.root.elements[1].insert_after before, paragraph
      end
    end

    temp = Rails.root.join 'tmp', Time.now.to_i.to_s

    Dir.mkdir temp

    source = Rails.root.join('assets', 'proposal_template')

    system("cp -r #{source}/. #{temp}  ")
    system "rm Rails.root.join('tmp', temp, 'word', 'footer1.xml')"
    system "rm Rails.root.join('tmp', temp, 'word', 'footer2.xml')"

    file = File.new Rails.root.join('tmp', temp, 'docProps', 'custom.xml'), 'w'
    file.write doc.to_s
    file.close

    file = File.new Rails.root.join('tmp', temp, 'word', 'document.xml'), 'w'
    file.write docbody.to_s
    file.close

    file = File.new(Rails.root.join('tmp', temp, 'word', 'header2.xml'), 'w')
    file.write header_1.to_s
    file.close

    system("cd #{temp} && zip -r proposal.docx .")

    temp
  end
end

