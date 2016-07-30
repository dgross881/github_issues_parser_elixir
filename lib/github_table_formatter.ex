defmodule GithubIssues.GithubTableFormatter do
  import  Enum, only: [each: 2, map: 2, map_join: 3, max: 1]
  @doc """
  Takes a list of row data, where each row is a Map, and a list of
  headers. Prints a table to STDOUT of the data from each row
  identified by each header. That is, each header identifies a column,
  and those columns are extracted and printed from rows. 0

  We calculate the width of each column to fit the longest element
  in that column
  """
  def printable_table_for_columns(rows, headers) do
    with data_columns = split_into_columns(rows, headers),
      column_widths = widths_of(data_columns),
      format = format_for(column_widths)
    do
      puts_one_line_in_column(headers, format)
      IO.puts(seperator(column_widths))
      put_in_columns(data_columns, format)
    end
  end

  @doc """
  Given a list of rows, where each row contains a keyed list
  of columns, return a list containing lists of the data in
  each column. The headers parameter contains the list of
  columns to extract.

  ## Example
    iex> list = [Enum.into([{"a", "1"}, {"b", "2"}, {"c", "3"} ], %{}),
    ...> Enum.into([{"a", "4"}, {"b", "5"}, {"c", "6"}], %{})]
    iex> GithubIssues.GithubTableFormatter.split_into_columns(list, ["a", "b", "c"])
    [["1", "4"], ["2", "5"], ["3", "6"]]
  """
  def split_into_columns(rows, headers) do
    for header <- headers, do: map(rows, &(printable(&1[header])))
  end

  @doc """
  Return a binary (string) version of our parameter.
  ## Examples
    iex> GithubIssues.GithubTableFormatter.printable("a")
    "a"
    iex> GithubIssues.GithubTableFormatter.printable(99)
    "99"
  """
  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  @doc """
  Given a doc list containing sublists, where each subject contains the data
  for a column, return a list containing the maximum width of each column

  ## Example
    iex> data = [ ["cat", "wombat", "elk"], ["mongoose", "ant", "gnu"] ]
    iex> GithubIssues.GithubTableFormatter.widths_of(data)
    [ 6, 8 ]
  """
  def widths_of(columns) do
    for column <- columns,  do: column |> map(&String.length/1) |> max
  end

  @doc """
  returns the format string hardcoded with | and ~-ns

  ## Example
    iex>  data = [5, 6, 99]
    iex>  GithubIssues.GithubTableFormatter.format_for(data)
    "~-5s | ~-6s | ~-99s~n"
  """
  def format_for(columns) do
    map_join(columns, " | ", &("~-#{&1}s")) <> "~n"
  end

  def put_in_columns(data_columns, format) do
    data_columns
      |> List.zip
      |> map(&Tuple.to_list/1)
      |> each(&(puts_one_line_in_column(&1, format)))
  end

  def puts_one_line_in_column(fields, format) do
    :io.format(format, fields)
  end


  @doc """
  Seperates the headers fomr the body of the table.
  It will duplicate "-" based off the max length of the table header

  ## Example

  iex> widths = [5, 6, 9]
  iex> GithubIssues.GithubTableFormatter.seperator(widths)
  "------+--------+----------"
  """
  def seperator(widths) do
    Enum.map_join(widths, "-+-", &String.duplicate("-", &1))
  end
end
