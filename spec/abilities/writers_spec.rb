require 'rails_helper'
require 'cancan/matchers'

describe Canard::Abilities, '#writers' do
  let(:acting_writer) { User.create(roles: %w(writer)) }
  let(:other_writer) { User.create(id: 2, roles: %w(writer)) }
  subject(:writer_ability) { Ability.new(acting_writer) }
  

  describe 'on Guide' do
    let(:guide) { Guide.create(user: acting_writer) }
    let(:other_guide) { Guide.create(user: other_writer) }
    

    it { is_expected.to be_able_to( :read, guide ) }
    it { is_expected.to be_able_to( :create, guide) }
    it { is_expected.to be_able_to( :update, guide) }
    it { is_expected.to be_able_to( :destroy, guide) }

    it { is_expected.to be_able_to( :read, other_guide ) }
    it { is_expected.not_to be_able_to(:update, other_guide) }
    it { is_expected.not_to be_able_to(:destroy, other_guide) }
  end
  
  describe 'on Review' do
    let(:review) { Review.create(user: acting_writer) }
    let(:other_review) { Review.create(user: other_writer)}

    it { is_expected.to be_able_to(:read, review) }
    it { is_expected.to be_able_to(:create, review) }
    it { is_expected.to be_able_to(:destroy, review) }

    it { is_expected.to be_able_to(:read, other_review) }
    it { is_expected.not_to be_able_to(:destroy, other_review) }
  end
end
