#encoding : utf-8
class Document

  attr_accessor :object, :client, :errors


  def initialize
    @errors = {}
  end

  def validate
    if object
     errors.delete 'object' if errors['object']
    else
      errors['object'] = 'не определен'
    end

    if client
      errors.delete 'client' if errors['client']
    else
      errors['client'] = 'не определен'
    end

    if errors.empty?
      puts 'no errors'
    else
      errors.inspect
    end
  end

  def skeleton
    validate
    return errors unless errors.empty?
    doc = properties
    #self.send(object.class.name.downcase)
    true while doc.root.delete_element "//property"

    counter = 2

    keys = object.attrs(client).keys

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
    doc
  end


  def contract
    docbody = body


    keys = object.attrs.keys
    keys.delete :s_name
    keys.delete :gifts

    for key in keys
      Rails.logger.info key
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


    for code in client.car.codes
      unless code[1] == 'Опция неизвестна'
        count = docbody.root.elements[1].elements.count
        before = docbody.root.elements[1].elements[count]
        paragraph = wp


        wr = REXML::Element.new 'w:r'

        wrPr = REXML::Element.new 'w:rPr'

        wrPr.add_element wrfonts
        wrPr.add_element wsz
        wrPr.add_element wszcs

        wr.add_element wrPr

        wt = REXML::Element.new 'w:t'
        wt.add_text code[1]

        wr.add_element wt

        paragraph.add_element wr

        docbody.root.elements[1].insert_before before, paragraph
      end
    end

    if gifts
      object.gifts.each do |key, value|
        unless value.to_s == "0"
          count = docbody.root.elements[1].elements.count
          before = docbody.root.elements[1].elements[count]
          paragraph = REXML::Element.new('w:p')
          paragraph.add_attribute 'w:rsidR', '000D076D'
          paragraph.add_attribute 'w:rsidRDefault', '000D076D'
          paragraph.add_attribute 'w:rsidP', "000D076D"

          pPr = REXML::Element.new 'w:pPr'
          wr = REXML::Element.new 'w:r'

          wrPr = REXML::Element.new 'w:rPr'

          wt = REXML::Element.new 'w:t'
          wt.add_text I18n.t("#{key}")

          wrPr.add_element wrfonts
          wrPr.add_element wsz
          wrPr.add_element wszcs

          wr.add_element wrPr
          wr.add_element wt

          paragraph.add_element wr

          docbody.root.elements[1].insert_before before, paragraph
        end
      end
    end

    temp = Rails.root.join 'tmp', Time.now.to_i.to_s

    Dir.mkdir temp

    source = Rails.root.join('assets', 'docx_template')

    system("cp -r #{source}/. #{temp}  ")

    system "rm Rails.root.join('tmp', temp, 'word', 'footer1.xml')"
    system "rm Rails.root.join('tmp', temp, 'word', 'footer2.xml')"

    File.new(Rails.root.join('tmp', temp, 'docProps', 'custom.xml'), 'w').write(skeleton).close
    File.new(Rails.root.join('tmp', temp, 'word', 'document.xml'), 'w').write(docbody.to_s).close
    File.new(Rails.root.join('tmp', temp, 'word', 'footer1.xml'), 'w').write(footer_1.to_s).close
    File.new(Rails.root.join('tmp', temp, 'word', 'footer2.xml'), 'w').write(footer_2.to_s).close

    system("cd #{temp} && zip -r договор.docx .")

    temp
  end

  def wrfonts
    element = REXML::Element.new 'w:rFonts'
    element.add_attribute 'w:ascii', 'CorporateS'
    element.add_attribute 'w:hAnsi', 'CorporateS'
    element
  end

  def wsz
    element = REXML::Element.new 'w:sz'
    element.add_attribute 'w:val', '20'
    element
  end

  def wszcs
    element = REXML::Element.new 'w:szCs'
    element.add_attribute 'w:val', '20'
    element

  end

  def wp
    element = REXML::Element.new('w:p')
    element.add_attribute 'w:rsidR', '000D076D'
    element.add_attribute 'w:rsidRDefault', '000D076D'
    element.add_attribute 'w:rsidP', "00100AA3"
    element.add_attribute 'w:rsidRPr', '00254ACB'
    element
  end

  def body
    REXML::Document.new File.new(Rails.root.join('assets', object.class.name.downcase, 'word', 'document.xml'), 'r').read
  end

  def properties
    REXML::Document.new File.new(Rails.root.join('assets', object.class.name.downcase, 'docProps', 'custom.xml'), 'r').read
  end

  def footer1
    REXML::Document.new File.new(Rails.root.join('assets', object.class.name.downcase, 'word', 'footer1.xml'), 'r').read
  end

  def footer2
    REXML::Document.new File.new(Rails.root.join('assets', object.class.name.downcase, 'word', 'footer2.xml'), 'r').read
  end

end