defmodule Katography.Filter do
  @moduledoc """
  Translates filters to Ecto queries
  """
  import Ecto.Query

  @default_filters [order: [%{desc: :updated_at}]]

  def filter_by(query, filters) when is_list(filters) do
    @default_filters
    |> Keyword.merge(filters)
    |> Enum.reduce(query, &filter_next/2)
  end

  # Pagination
  def filter_next({:pagination, %{limit: limit}}, query) do
    limit(query, ^limit)
  end

  def filter_next({:pagination, %{offset: offset}}, query) do
    offset(query, ^offset)
  end

  def filter_next({field, {:in, values}}, query) do
    where(query, [r], field(r, ^field) in ^values)
  end

  def filter_next({field, :in_past}, query) do
    where(query, [a], field(a, ^field) < ^Timex.now())
  end

  def filter_next({field, :in_future}, query) do
    where(query, [a], field(a, ^field) > ^Timex.now())
  end

  def filter_next({field, predicates}, query) when is_map(predicates) do
    Enum.reduce(predicates, query, fn predicate, query ->
      filter_next({field, predicate}, query)
    end)
  end

  def filter_next({field, {:not, value}}, query),
    do: where(query, [a], field(a, ^field) != ^value)

  def filter_next({field, :not_nil}, query), do: where(query, [a], not is_nil(field(a, ^field)))

  def filter_next({field, {:older_than, datetime}}, query),
    do: where(query, [a], field(a, ^field) < ^datetime)

  def filter_next({field, {:newer_than, datetime}}, query),
    do: where(query, [a], field(a, ^field) > ^datetime)

  def filter_next({field, {:gt, value}}, query), do: where(query, [a], field(a, ^field) > ^value)
  def filter_next({field, {:lt, value}}, query), do: where(query, [a], field(a, ^field) < ^value)

  def filter_next({field, {:gte, value}}, query),
    do: where(query, [a], field(a, ^field) >= ^value)

  def filter_next({field, {:lte, value}}, query),
    do: where(query, [a], field(a, ^field) <= ^value)

  def filter_next({field, {:eq, nil}}, query), do: where(query, [a], is_nil(field(a, ^field)))
  def filter_next({field, {:eq, value}}, query), do: where(query, [a], field(a, ^field) == ^value)

  def filter_next({field, {:ilike, list}}, query) when is_list(list) do
    Enum.reduce(list, query, fn q, query ->
      q = "%#{q}%"
      where(query, [qq], ilike(field(qq, ^field), ^q))
    end)
  end

  def filter_next({field, {:ilike_any, patterns}}, query) when is_list(patterns) do
    patterns = Enum.map(patterns, fn pattern -> "%#{pattern}%" end)

    conditions =
      Enum.reduce(patterns, false, fn pattern, acc_condition ->
        dynamic([r], ^acc_condition or ilike(field(r, ^field), ^pattern))
      end)

    where(query, ^conditions)
  end

  def filter_next({:query, {q, fields}}, query) when is_list(fields) do
    conditions =
      Enum.reduce(fields, false, fn field, conditions ->
        dynamic([qq], ^conditions or ilike(field(qq, ^field), ^"%#{q}%"))
      end)

    where(query, ^conditions)
  end

  def filter_next({:query, {q, f}}, query) do
    q = "%#{q}%"
    where(query, [qq], ilike(field(qq, ^f), ^q))
  end

  # Dynamic conditions
  def filter_next({:conditions, conditions}, query) do
    where(query, ^conditions)
  end

  # Pagination
  def filter_next({:limit, limit}, query) do
    limit(query, ^limit)
  end

  def filter_next({:offset, offset}, query) do
    offset(query, ^offset)
  end

  # Ordering
  def filter_next({:order, opts}, query) do
    Enum.reduce(opts, query, &order_next/2)
  end

  def filter_next({field, {:ilike, value}}, query) do
    q = "%#{value}%"
    where(query, [qq], ilike(field(qq, ^field), ^q))
  end

  def filter_next({field, value}, query) do
    where(query, [r], field(r, ^field) == ^value)
  end

  def order_next(%{desc: {:coalesce, [f1, f2]}}, query) do
    order_by(query, [r], desc: coalesce(field(r, ^f1), field(r, ^f2)))
  end

  def order_next(%{asc: field}, query) do
    order_by(query, [r], asc: field(r, ^field))
  end

  def order_next(%{desc: field}, query) do
    order_by(query, [r], desc: field(r, ^field))
  end

  def order_next(%{random: true}, query) do
    order_by(query, [r], fragment("RANDOM()"))
  end
end
