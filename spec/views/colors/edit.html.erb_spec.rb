require 'spec_helper'

describe "colors/edit" do
  before(:each) do
    @color = assign(:color, stub_model(Color,
      :code => "MyString",
      :desc => "MyString",
      :color => "MyString"
    ))
  end

  it "renders the edit color form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => colors_path(@color), :method => "post" do
      assert_select "input#color_code", :name => "color[code]"
      assert_select "input#color_desc", :name => "color[desc]"
      assert_select "input#color_color", :name => "color[color]"
    end
  end
end
