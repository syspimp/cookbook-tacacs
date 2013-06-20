require "chefspec"

describe "tacacs::default" do
  before do
    admins = [
      { "id" => "foo" },
      { "id" => "bar" }
    ]
    viewers = [
      { "id" => "foo" },
      { "id" => "bar" },
      { "id" => "baz" }
    ]
    ::Chef::Recipe.any_instance.stub(:search).
      with(:users, "tacacs:admin AND (admin:_default OR admin:all)").
      and_return admins
    ::Chef::Recipe.any_instance.stub(:search).
      with(:users, "tacacs:viewonly AND (viewonly:_default OR viewonly:all)").
      and_return viewers
    @chef_run = ::ChefSpec::ChefRunner.new.converge "tacacs::default"
  end

  it "installs package" do
    @chef_run.should upgrade_package "tacacs+"
  end

  it "starts service" do
    @chef_run.should start_service "tacacs_plus"
  end

  it "enables service" do
    @chef_run.should set_service_to_start_on_boot "tacacs_plus"
  end

  describe "/etc/default/tacacs+" do
    before { @file = "/etc/default/tacacs+" }

    it "has proper owner" do
      @chef_run.template(@file).should be_owned_by("root", "root")
    end

    it "has proper modes" do
      m = @chef_run.template(@file).mode

      sprintf("%o", m).should == "644"
    end
  end

  describe "/etc/tacacs+/tac_plus.conf+" do
    before { @file = "/etc/tacacs+/tac_plus.conf" }

    it "has proper owner" do
      @chef_run.template(@file).should be_owned_by("root", "root")
    end

    it "has proper modes" do
      m = @chef_run.template(@file).mode

      sprintf("%o", m).should == "640"
    end
  end
end
