require 'spec_helper'

describe "clients/show" do
  before(:each) do
    @client = assign(:client, stub_model(Client,
      :fio => "Fio",
      :comment => "MyText",
      :phone1 => "Phone1",
      :phone2 => "Phone2",
      :phone3 => "Phone3",
      :phone4 => "Phone4",
      :adress => "Adress",
      :brand => "Brand",
      :manager => "Manager",
      :model => "Model",
      :icon => 1,
      :creditmanager => "Creditmanager",
      :icon2 => 2,
      :vin => "Vin",
      :cost => 3,
      :status => "Status",
      :commercial => "Commercial",
      :tmp => "Tmp",
      :files => 4,
      :phone11 => "Phone11",
      :phone22 => "Phone22",
      :phone33 => "Phone33",
      :phone44 => "Phone44",
      :email => "Email",
      :pas1 => "Pas1",
      :pas2 => "Pas2",
      :pas3 => "Pas3",
      :prepay => 1.5,
      :carpets => false,
      :mudguard => false,
      :tech_1 => false,
      :tech_2 => false,
      :tires => false,
      :client_adress => "Client Adress",
      :cause => 5,
      :trade_in_price => 6,
      :trade_in_desc => "MyText",
      :used_vin => "Used Vin"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Fio/)
    rendered.should match(/MyText/)
    rendered.should match(/Phone1/)
    rendered.should match(/Phone2/)
    rendered.should match(/Phone3/)
    rendered.should match(/Phone4/)
    rendered.should match(/Adress/)
    rendered.should match(/Brand/)
    rendered.should match(/Manager/)
    rendered.should match(/Model/)
    rendered.should match(/1/)
    rendered.should match(/Creditmanager/)
    rendered.should match(/2/)
    rendered.should match(/Vin/)
    rendered.should match(/3/)
    rendered.should match(/Status/)
    rendered.should match(/Commercial/)
    rendered.should match(/Tmp/)
    rendered.should match(/4/)
    rendered.should match(/Phone11/)
    rendered.should match(/Phone22/)
    rendered.should match(/Phone33/)
    rendered.should match(/Phone44/)
    rendered.should match(/Email/)
    rendered.should match(/Pas1/)
    rendered.should match(/Pas2/)
    rendered.should match(/Pas3/)
    rendered.should match(/1.5/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/Client Adress/)
    rendered.should match(/5/)
    rendered.should match(/6/)
    rendered.should match(/MyText/)
    rendered.should match(/Used Vin/)
  end
end
