defmodule GithubIssues.GithubRequest do
  require Logger
  @github_token Application.get_env(:github_issues, :github_token)
  @github_url Application.get_env(:github_issues, :github_url)
  @headers [ {"User-agent", "Elixir dgross881@gmail.com" }, {"Authorization", @github_token} ]

  def fetch(user, project) do
    Logger.info "Fetching user #{user}'s project #{project}"
    issues_url(user, project)
    |> HTTPoison.get(@headers)
    |> handle_response
  end

  def issues_url(user, project) do
   "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status_code: 200, body: body }}) do
    Logger.info "Successful response"
    Logger.debug fn -> inpect(body) end
    {:ok, Poison.Parser.parse!(body)}
  end

  def handle_response({_, %{ status_code: status, body: body} }) do
    Logger.error "Error #{status} returned"
    {:error, Poison.Parser.parse!(body)}
  end
end
