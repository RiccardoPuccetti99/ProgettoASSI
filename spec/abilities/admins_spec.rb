require 'rails_helper'
require 'cancan/matchers'

describe Canard::Abilities, '#admins' do
  let(:acting_admin) { User.create(roles: %w(admin)) }
  subject(:admin_ability) { Ability.new(acting_admin) }

#   # Define your ability tests thus;
#   describe 'on Admin' do
#     let(:admin) { FactoryGirl.create(admin) }
#
#     it { is_expected.to be_able_to(:index,   Admin) }
#     it { is_expected.to be_able_to(:show,    admin) }
#     it { is_expected.to be_able_to(:read,    admin) }
#     it { is_expected.to be_able_to(:new,     admin) }
#     it { is_expected.to be_able_to(:create,  admin) }
#     it { is_expected.to be_able_to(:edit,    admin) }
#     it { is_expected.to be_able_to(:update,  admin) }
#     it { is_expected.to be_able_to(:destroy, admin) }
#   end
#   # on Admin
end
