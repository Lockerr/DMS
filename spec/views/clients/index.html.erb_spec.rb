require 'spec_helper'

describe "clients/index" do
  before(:each) do
    assign(:clients, [
      stub_model(Client,
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
      ),
      stub_model(Client,
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
      )
    ])
  end

  it "renders a list of clients" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Fio".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Phone1".to_s, :count => 2
    assert_select "tr>td", :text => "Phone2".to_s, :count => 2
    assert_select "tr>td", :text => "Phone3".to_s, :count => 2
    assert_select "tr>td", :text => "Phone4".to_s, :count => 2
    assert_select "tr>td", :text => "Adress".to_s, :count => 2
    assert_select "tr>td", :text => "Brand".to_s, :count => 2
    assert_select "tr>td", :text => "Manager".to_s, :count => 2
    assert_select "tr>td", :text => "Model".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Creditmanager".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Vin".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "Commercial".to_s, :count => 2
    assert_select "tr>td", :text => "Tmp".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Phone11".to_s, :count => 2
    assert_select "tr>td", :text => "Phone22".to_s, :count => 2
    assert_select "tr>td", :text => "Phone33".to_s, :count => 2
    assert_select "tr>td", :text => "Phone44".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Pas1".to_s, :count => 2
    assert_select "tr>td", :text => "Pas2".to_s, :count => 2
    assert_select "tr>td", :text => "Pas3".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Client Adress".to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Used Vin".to_s, :count => 2
  end
end
