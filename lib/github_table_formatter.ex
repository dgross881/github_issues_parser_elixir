defmodule GithubIssues.GithubTableFormatter do
  import  Enum, only: [each: 2, map: 2, map_join: 3, max: 1]

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

  def split_into_columns(rows, headers) do
    for header <- headers, do: map(rows, &(printable(&1[header])))
  end

  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def widths_of(columns) do
    for column <- columns,  do: column |> map(&String.length/1) |> max
  end

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

  def seperator(widths) do
    Enum.map_join(widths, "-+-", &String.duplicate("-", &1))
  end
end
