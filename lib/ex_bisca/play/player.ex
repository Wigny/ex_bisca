defmodule ExBisca.Play.Player do
  @type id :: binary
  @type t :: %__MODULE__{id: id, name: binary}

  @enforce_keys [:id, :name]
  defstruct [:id, :name]

  @spec new(name :: binary) :: t
  def new(name) do
    id = Base.url_encode64(:crypto.strong_rand_bytes(16), padding: false)
    %__MODULE__{id: id, name: name}
  end
end
