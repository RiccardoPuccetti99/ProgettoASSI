Canard::Abilities.for(:writer) do
  can [:update, :destroy], Guide, {user_id: user.id}
end
