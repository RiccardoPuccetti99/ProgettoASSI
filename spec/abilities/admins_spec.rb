require 'rails_helper'
require 'cancan/matchers'

describe Canard::Abilities, '#admins' do
  let(:acting_admin) { User.create(roles: %w(admin)) }
  let(:other_writer) { User.create(id: 2, roles: %w(writer)) }
  subject(:admin_ability) { Ability.new(acting_admin) }

  describe 'on Guide' do
    let(:guide) { Guide.create(user: acting_admin) }
    let(:other_guide) { Guide.create(user: other_writer) }

    it { is_expected.to be_able_to( :read, guide ) }
    it { is_expected.to be_able_to( :create, guide) }
    it { is_expected.to be_able_to( :update, guide) }
    it { is_expected.to be_able_to( :destroy, guide) }

    it { is_expected.to be_able_to( :read, other_guide ) }
    it { is_expected.to be_able_to(:update, other_guide) }
    it { is_expected.to be_able_to(:destroy, other_guide) }
  end
  
  describe 'on Review' do
    let(:review) { Review.create(user: acting_admin) }
    let(:other_review) { Review.create(user: other_writer)}

    it { is_expected.to be_able_to(:read, review) }
    it { is_expected.to be_able_to(:create, review) }
    it { is_expected.to be_able_to(:destroy, review) }

    it { is_expected.to be_able_to(:read, other_review) }
    it { is_expected.to be_able_to(:destroy, other_review) }
  end
end
