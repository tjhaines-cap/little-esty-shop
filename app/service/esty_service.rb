class EstyService

  def repo
    get_url("https://api.github.com/repos/ColinReinhart/little-esty-shop")
  end

  def repo_usernames
    get_url("https://api.github.com/repos/ColinReinhart/little-esty-shop/contributors")
  end

  def commits(url)
    get_url(url)
  end

  def prs
    get_url("https://api.github.com/repos/ColinReinhart/little-esty-shop/pulls?state=closed&per_page=100'")
  end

  def upcoming_holidays
    get_url("https://date.nager.at/api/v3/NextPublicHolidays/US")
  end

  def get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end
