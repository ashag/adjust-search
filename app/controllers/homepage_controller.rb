class HomepageController < ApplicationController
  include GithubApi
  before_action :github_search_params, only: [:search_results]
  before_action :search_request, only: [:search_results]


  def main; end

  def search_results
    case @results.code
    when 200
      @parsed_results = GithubApi.parse_response(@results.body)
    when 422
      @error_messages = JSON.parse(@results.body)['errors']
    else
      render
    end
  end

  private
  def search_request
    @results = GithubApi.http_request(@params)
  end

  def github_search_params
    @params = params.permit(:topic, :user, :language)
  end
end
