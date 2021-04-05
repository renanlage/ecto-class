defmodule EctoClass.Factory do
  @moduledoc false

  alias EctoClass.Profiles.Schemas.Organization
  alias EctoClass.Repo

  @iso8601_structs [
    Date,
    DateTime,
    NaiveDateTime,
    Time
  ]

  @doc "Returns a map with the build params"
  @spec params_for(factory_name :: atom(), attributes :: keyword()) :: map()
  def params_for(factory_name, attributes \\ [])
      when is_atom(factory_name) and is_list(attributes) do
    factory_name
    |> build()
    |> to_map()
  end

  @doc "Returns an schema struct with the given params"
  @spec build(factory_name :: atom()) :: struct()
  def build(:organization) do
    %Organization{
      legal_name: "Random Legal Name #{:rand.uniform(99_999_999)}",
      document: Brcpfcnpj.cnpj_generate(),
      document_type: "cnpj"
    }
  end

  @doc "Returns the a model struct with the given attributes"
  @spec build(factory_name :: atom(), attributes :: keyword()) :: struct()
  def build(factory_name, attributes \\ []) when is_atom(factory_name) and is_list(attributes) do
    factory_name
    |> build()
    |> struct!(attributes)
  end

  @doc "Inserts a model with the given attributes on database"
  @spec insert!(factory_name :: atom(), attributes :: keyword()) :: struct()
  def insert!(factory_name, attributes \\ []) when is_atom(factory_name) do
    factory_name
    |> build(attributes)
    |> Repo.insert!()
  end

  @doc "Inserts a list of the given model on database"
  @spec insert_list!(
          factory_name :: atom(),
          count :: integer(),
          attributes :: keyword()
        ) :: list(struct())
  def insert_list!(factory_name, count \\ 10, attributes \\ []) when is_atom(factory_name),
    do: Enum.map(1..count, fn _ -> insert!(factory_name, attributes) end)

  @doc "Transforms a struct and its inner fields to atom-maps"
  @spec to_map(instance :: map(), key_type :: :string_keys | :atom_keys) :: map()
  def to_map(instance, key_type \\ :atom_keys) do
    instance
    |> Map.drop([:__struct__, :__meta__])
    |> Map.new(fn
      {key, value} -> {cast_key(key, key_type), do_cast_to_map(value, key_type)}
    end)
  end

  defp do_cast_to_map(%schema{} = struct, key_type) do
    case schema do
      schema when schema in @iso8601_structs ->
        struct

      _ ->
        struct
        |> Map.from_struct()
        |> do_cast_to_map(key_type)
    end
  end

  defp do_cast_to_map(map, key_type) when is_map(map) do
    map
    |> Map.drop([:__meta__])
    |> Map.to_list()
    |> Enum.map(fn
      {k, v} -> {cast_key(k, key_type), do_cast_to_map(v, key_type)}
    end)
    |> Enum.into(%{})
  end

  defp do_cast_to_map(list, key_type) when is_list(list) do
    Enum.map(list, fn
      {k, v} -> {cast_key(k, key_type), do_cast_to_map(v, key_type)}
      v -> do_cast_to_map(v, key_type)
    end)
  end

  defp do_cast_to_map(value, _key_type), do: value

  defp cast_key(key, :atom_keys), do: to_atom(key)
  defp cast_key(key, :string_keys), do: to_string(key)

  defp to_atom(v) when is_atom(v), do: v
  defp to_atom(v), do: String.to_atom(v)
end
