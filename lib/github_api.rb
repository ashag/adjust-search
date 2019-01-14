require 'httparty'

module GithubApi
  class << self

    GITHUB_API_URL = 'https://api.github.com/search/repositories?q='

    def http_request(params)
      return if params.nil?

      search_request = GITHUB_API_URL + build_query(params)

      HTTParty.get(search_request)
    end

    def build_query(params)
      query = []

      params.to_h.map do |k,v|
        next if v.empty?

        if result = GithubApi.send("build_#{k}", v)
          query << result
        end
      end

      query.join('+')
    end

    def build_topic(keywords)
      split_keywords = keywords.split(' ')
      split_keywords.inject('') do |search, keyword|
        search << keyword

        unless split_keywords[-1] == keyword
          search << '+'
        end
        search
      end
    end

    def build_user(user)
      "user:#{user}"
    end

    def build_language(language)
      "language:#{language}"
    end

    def parse_response(response)
      parsed_response = JSON.parse(response)

      [].tap do |results_list|
        byebug
        parsed_response['items'].map do |item|
          byebug
          results_list << {}.tap do |h|
            h['name'] = item['name']
            h['owner'] = item['owner']['login']
            h['description'] = item['description']
            h['url'] = item['url']
          end
        end
      end
    end
  end
end
