require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject(:comment) { FactoryBot.build(:comment) }

  describe "validations" do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:author_id) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:type_id) }
  end
end
