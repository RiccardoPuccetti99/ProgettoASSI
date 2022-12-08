require 'rails_helper'
require 'cancan/matchers'

describe Canard::Abilities, '#users' do
  let(:acting_user) { User.create(roles: %w(user)) }
  subject(:user_ability) { Ability.new(acting_user) }

#   # Define your ability tests thus;
#   describe 'on User' do
#     let(:user) { FactoryGirl.create(user) }
#
#     it { is_expected.to be_able_to(:index,   User) }
#     it { is_expected.to be_able_to(:show,    user) }
#     it { is_expected.to be_able_to(:read,    user) }
#     it { is_expected.to be_able_to(:new,     user) }
#     it { is_expected.to be_able_to(:create,  user) }
#     it { is_expected.to be_able_to(:edit,    user) }
#     it { is_expected.to be_able_to(:update,  user) }
#     it { is_expected.to be_able_to(:destroy, user) }
#   end
#   # on User
end
