require 'spec_helper'

describe "interiors/show" do
  before(:each) do
    @interior = assign(:interior, stub_model(Interior,
      :desc => "Desc",
      :code => "Code",
      :klasse_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Desc/)
    rendered.should match(/Code/)
    rendered.should match(/1/)
  end
end
