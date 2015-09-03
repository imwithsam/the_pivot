require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:role) do
    Role.new(name: "registered_user")
  end

  it "creates a role" do
    role.save

    expect(Role.first.name).to eq("registered_user")
  end

  it "must have a name" do
    role.name = nil

    expect(role).to be_invalid
  end
end
