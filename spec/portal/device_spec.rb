require 'spec_helper'

describe Spaceship::Device do
  before { Spaceship.login }
  let(:client) { Spaceship::Device.client }

  subject(:all_devices) { Spaceship::Device.all }
  it "successfully loads and parses all devices" do
    expect(all_devices.count).to eq(4)
    device = all_devices.first
    expect(device.id).to eq('AAAAAAAAAA')
    expect(device.name).to eq('Felix\'s iPhone')
    expect(device.udid).to eq('a03b816861e89fac0a4da5884cb9d2f01bd5641e')
    expect(device.platform).to eq('ios')
    expect(device.status).to eq('c')
    expect(device.model).to eq('iPhone 5 (Model A1428)')
    expect(device.device_type).to eq('iphone')
  end

  subject(:all_phones) { Spaceship::Device.all_iphones }
  it "successfully loads and parses all iPhones" do
    expect(all_phones.count).to eq(3)
    device = all_phones.first
    expect(device.id).to eq('AAAAAAAAAA')
    expect(device.name).to eq('Felix\'s iPhone')
    expect(device.udid).to eq('a03b816861e89fac0a4da5884cb9d2f01bd5641e')
    expect(device.platform).to eq('ios')
    expect(device.status).to eq('c')
    expect(device.model).to eq('iPhone 5 (Model A1428)')
    expect(device.device_type).to eq('iphone')
  end

  subject(:all_ipods) { Spaceship::Device.all_ipod_touches }
  it "successfully loads and parses all iPods" do
    expect(all_ipods.count).to eq(1)
    device = all_ipods.first
    expect(device.id).to eq('CCCCCCCCCC')
    expect(device.name).to eq('Personal iPhone')
    expect(device.udid).to eq('97467684eb8dfa3c6d272eac3890dab0d001c706')
    expect(device.platform).to eq('ios')
    expect(device.status).to eq('c')
    expect(device.model).to eq(nil)
    expect(device.device_type).to eq('ipod')
  end



  it "inspect works" do
    expect(subject.first.inspect).to include("Portal::Device")
  end

  describe "#find" do
    it "finds a device by its ID" do
      device = Spaceship::Device.find("AAAAAAAAAA")
      expect(device.id).to eq("AAAAAAAAAA")
      expect(device.udid).to eq("a03b816861e89fac0a4da5884cb9d2f01bd5641e")
    end
  end

  describe "#create" do
    it "should create and return a new device" do
      expect(client).to receive(:create_device!).with("Demo Device", "7f6c8dc83d77134b5a3a1c53f1202b395b04482b").and_return({})
      device = Spaceship::Device.create!(name: "Demo Device", udid: "7f6c8dc83d77134b5a3a1c53f1202b395b04482b")
    end

    it "should fail to create a nil device UDID" do
      expect {
        Spaceship::Device.create!(name: "Demo Device", udid: nil)
      }.to raise_error("You cannot create a device without a device_id (UDID) and name")
    end

    it "should fail to create a nil device name" do
      expect {
        Spaceship::Device.create!(name: nil, udid: "7f6c8dc83d77134b5a3a1c53f1202b395b04482b")
      }.to raise_error("You cannot create a device without a device_id (UDID) and name")
    end

    it "raises an exception if the device ID is already registererd" do
      expect {
        device = Spaceship::Device.create!(name: "Demo", udid: "e5814abb3b1d92087d48b64f375d8e7694932c39")
      }.to raise_error "The device UDID 'e5814abb3b1d92087d48b64f375d8e7694932c39' already exists on this team."
    end

    it "raises an exception if the device name is already registererd" do
      expect {
        # "Personal iPhone" is already taken
        device = Spaceship::Device.create!(name: "Personal iPhone", udid: "asdfasdf")
      }.to raise_error "The device name 'Personal iPhone' already exists on this team, use different one."
    end
  end
end
