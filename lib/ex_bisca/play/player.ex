defmodule ExBisca.Play.Player do
  use TypedStruct

  @type id :: atom

  typedstruct enforce: true do
    field :id, id
    field :name, binary
  end

  def new(name) do
    %__MODULE__{id: SecureRandom.hex(), name: name}
  end
end
