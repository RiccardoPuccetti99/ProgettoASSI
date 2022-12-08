require 'rails_helper'
require 'cancan/matchers'

describe Canard::Abilities, '#writers' do
  let(:acting_writer) { User.create(roles: %w(writer)) }
  subject(:writer_ability) { Ability.new(acting_writer) }

#   # Define your ability tests thus;
#   describe 'on Writer' do
#     let(:writer) { FactoryGirl.create(writer) }
#
#     it { is_expected.to be_able_to(:index,   Writer) }
#     it { is_expected.to be_able_to(:show,    writer) }
#     it { is_expected.to be_able_to(:read,    writer) }
#     it { is_expected.to be_able_to(:new,     writer) }
#     it { is_expected.to be_able_to(:create,  writer) }
#     it { is_expected.to be_able_to(:edit,    writer) }
#     it { is_expected.to be_able_to(:update,  writer) }
#     it { is_expected.to be_able_to(:destroy, writer) }
#   end
#   # on Writer
end
