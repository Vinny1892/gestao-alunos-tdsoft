defmodule GestaoAlunos.Pagination do
  import Ecto.Query
  alias GestaoAlunos.Repo

  def query(query, page, per_page: per_page) when is_bitstring(page) do
    query(query, String.to_integer(page), per_page: per_page)
  end

  def query(query, page, per_page: per_page) do
    query
    |> limit(^(per_page ))
    |> offset(^(per_page * (page - 1)))
    |> Repo.all()
  end

  def page(query, page, per_page: per_page) when is_bitstring(page) do
    page(query, String.to_integer(page), per_page: per_page)
  end

  def page(query, page, per_page: per_page) do
    results = query(query, page, per_page: per_page)
    has_next = length(results) > per_page
    has_prev = page > 1
    count = Repo.one(from(t in subquery(query), select: count("*")))
    IO.inspect "___________________________SEILA____________________________________________________"
    IO.inspect results

    %{
      has_next: has_next,
      has_prev: has_prev,
      prev_page: page - 1,
      page: page,
      next_page: page + 1,
      first: (page - 1) * per_page + 1,
      last: Enum.min([page * per_page, count]),
      count: count,
      list: results
    }
  end
end