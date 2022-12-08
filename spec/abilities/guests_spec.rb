require 'rails_helper'
require 'cancan/matchers'

describe Canard::Abilities, '#guests' do
  let(:acting_guest) { User.create(roles: %w(guest)) }
  subject(:guest_ability) { Ability.new(acting_guest) }

#   # Define your ability tests thus;
#   describe 'on Guest' do
#     let(:guest) { FactoryGirl.create(guest) }
#
#     it { is_expected.to be_able_to(:index,   Guest) }
#     it { is_expected.to be_able_to(:show,    guest) }
#     it { is_expected.to be_able_to(:read,    guest) }
#     it { is_expected.to be_able_to(:new,     guest) }
#     it { is_expected.to be_able_to(:create,  guest) }
#     it { is_expected.to be_able_to(:edit,    guest) }
#     it { is_expected.to be_able_to(:update,  guest) }
#     it { is_expected.to be_able_to(:destroy, guest) }
#   end
#   # on Guest
end
