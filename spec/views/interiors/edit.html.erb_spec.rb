require 'spec_helper'

describe "interiors/edit" do
  before(:each) do
    @interior = assign(:interior, stub_model(Interior,
      :desc => "MyString",
      :code => "MyString",
      :klasse_id => 1
    ))
  end

  it "renders the edit interior form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => interiors_path(@interior), :method => "post" do
      assert_select "input#interior_desc", :name => "interior[desc]"
      assert_select "input#interior_code", :name => "interior[code]"
      assert_select "input#interior_klasse_id", :name => "interior[klasse_id]"
    end
  end
end
