defmodule ExBisca.Play.Player do
  use TypedStruct

  @type id :: atom
  @typep name :: binary

  typedstruct enforce: true do
    field :id, id
    field :name, name
  end

  @spec new(name) :: t
  def new(name), do: struct!(__MODULE__, id: SecureRandom.hex(), name: name)
end
