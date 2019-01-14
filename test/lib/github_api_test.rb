require 'minitest/autorun'
require 'byebug'
require './lib/github_api'
require 'webmock/minitest'

class GithubApiTest < Minitest::Test

  GITHUB_RESPONSE = "{
    total_count: 1,
    items: [
      {
        name: 'sloth',
        owner: {
          login: 'adies'
        },
        description: 'this is an app about sloths',
        url: 'https://api.github.com/repos/adies/sloth'
      }
    ]
  }"

  def test_nothing_is_returned_if_params_nil
    refute GithubApi.http_request(nil)
  end

  def test_github_request_is_made
    stub_request(:get, "https://api.github.com/search/repositories?q=sloth").
      to_return(status: 200, body: GITHUB_RESPONSE, headers: {})

    assert GithubApi.http_request({"topic"=>"sloth", "user"=>"", "language"=>""}), GITHUB_RESPONSE
  end

  def test_build_user
    assert_equal GithubApi.build_user('adies'), 'user:adies'
  end

  def test_build_language
    assert_equal GithubApi.build_language('ruby'), 'language:ruby'
  end
end
