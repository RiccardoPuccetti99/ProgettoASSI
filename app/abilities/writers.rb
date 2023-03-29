Canard::Abilities.for(:writer) do
  can [:update, :destroy], Guide, {user_id: user.id}
  can [:read, :create], [Guide, Review]
  can [:destroy], Review, {user_id: user.id}
end
