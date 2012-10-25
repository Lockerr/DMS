require 'spec_helper'

describe "interiors/index" do
  before(:each) do
    assign(:interiors, [
      stub_model(Interior,
        :desc => "Desc",
        :code => "Code",
        :klasse_id => 1
      ),
      stub_model(Interior,
        :desc => "Desc",
        :code => "Code",
        :klasse_id => 1
      )
    ])
  end

  it "renders a list of interiors" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Desc".to_s, :count => 2
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
