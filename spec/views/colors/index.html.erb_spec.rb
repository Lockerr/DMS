require 'spec_helper'

describe "colors/index" do
  before(:each) do
    assign(:colors, [
      stub_model(Color,
        :code => "Code",
        :desc => "Desc",
        :color => "Color"
      ),
      stub_model(Color,
        :code => "Code",
        :desc => "Desc",
        :color => "Color"
      )
    ])
  end

  it "renders a list of colors" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => "Desc".to_s, :count => 2
    assert_select "tr>td", :text => "Color".to_s, :count => 2
  end
end
