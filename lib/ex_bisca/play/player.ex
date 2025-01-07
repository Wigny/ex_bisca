defmodule ExBisca.Play.Player do
  @type id :: binary
  @type t :: %__MODULE__{id: id, name: binary}

  @enforce_keys [:id, :name]
  defstruct [:id, :name]

  def new(name) do
    %__MODULE__{id: Base.url_encode64(:crypto.strong_rand_bytes(16), padding: false), name: name}
  end
end
