defmodule EctoClass do
  @moduledoc """
  Exemple postgress and Ecto application.

  EctoClass is an application created for Stones Elixir Formation Program
  students in order to serve as an exemple of an application running
  a postgress database with Ecto.

  Ecto is an DSL (domain-specific language) that is used on elixir in order to
  "convert" elixir code into an sql database sintax.

  One exemple of this could be something like:

  ```elixir
  import Ecto.Query

  from u in "users",
    join: a in "affiliations",
    on: u.id in a.user_id,
    where: u.username = "myusername@gmail.com",
    select: %{id: u.id, username: u.username}
  ```

  This could also be translated to something like:

  ```elixir
  import Ecto.Query

  Users
  |> join([u], a in Affiliations, on: u.id == a.user_id)
  |> where([u], u.username == ^"myusername")
  |> select([u], %{id: u.id, username: u.username})
  ```

  Or into an SQL version:

  ```sql
  SELECT id, username from users as u
    inner join affiliations as a on u.id == a.user_id
    where u.username = 'myusername@gmail.com'
  ```

  Ecto is split into 4 main components:

  - Ecto.Repo - repositories are wrappers around the data store.
    Via the repository, we can create, update, destroy and query existing entries.
    A repository needs an adapter and credentials to communicate to the database

  - Ecto.Schema - schemas are used to map any data source into an Elixir struct.
    We will often use them to map tables into Elixir data but that's one of their
    use cases and not a requirement for using Ecto

  - Ecto.Changeset - changesets provide a way for developers to filter and cast external parameters,
    as well as a mechanism to track and validate changes before they are applied to your data

  - Ecto.Query - written in Elixir syntax, queries are used to retrieve information from a given repository.
    Queries in Ecto are secure, avoiding common problems like SQL Injection, while still being composable,
    allowing developers to build queries piece by piece instead of all at once
  """
end
