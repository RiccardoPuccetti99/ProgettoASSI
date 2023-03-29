require 'rails_helper'
require 'cancan/matchers'

describe Canard::Abilities, '#guests' do
  subject(:guest_ability) { Ability.new(nil) }

  describe 'on Guide' do
    let(:guide) { Guide.create }
  
    it { is_expected.to be_able_to( :read, guide ) }
    it { is_expected.not_to be_able_to( :create, guide) }
    it { is_expected.not_to be_able_to( :update, guide) }
    it { is_expected.not_to be_able_to( :destroy, guide) }
  end
  
  describe 'on Review' do
    let(:review) { Review.create }
  
    it { is_expected.to be_able_to(:read, review) }
    it { is_expected.not_to be_able_to(:create, review) }
    it { is_expected.not_to be_able_to(:destroy, review) }
  end
  
end



