require 'spec_helper'

describe "interiors/new" do
  before(:each) do
    assign(:interior, stub_model(Interior,
      :desc => "MyString",
      :code => "MyString",
      :klasse_id => 1
    ).as_new_record)
  end

  it "renders new interior form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => interiors_path, :method => "post" do
      assert_select "input#interior_desc", :name => "interior[desc]"
      assert_select "input#interior_code", :name => "interior[code]"
      assert_select "input#interior_klasse_id", :name => "interior[klasse_id]"
    end
  end
end
