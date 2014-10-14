class RepositoriesController < ApplicationController
  before_action :authorize

  def index
    user_site = Regexp.new("^#{current_user['login']}\.github\.(io|com)$")
    @repositories = client.repositories.map{|r| GHRepository.new(client, r) }
    @grouped_repositories = @repositories.group_by{|r| r.name =~ user_site ? :main_site : r.name =~ /\.github\.(io|com)/ ? :forked_user_sites : :unknowns}
    @main_blog = @grouped_repositories[:main_site] || []
    @forked_user_blogs = @grouped_repositories[:forked_user_sites] || []
    @forked_user_blogs.sort_by do |a,b|
      if a.nil?
        1
      elsif b.nil?
        -1
      elsif a.name =~ user_site
        -1
      elsif a.name =~ user_site
        1
      else
        a.name <=> b.name
      end
    end
    @unknown_repositories = @grouped_repositories[:unknowns] || []
  end

  def fork
    repo_to_fork = 'jekyll_default_template'
    client.fork(owner: 'kissmyblog', repo: repo_to_fork)
    repo = GHRepository.new(client, client.repository(owner: current_user['login'], repo: repo_to_fork))
    repo.move_contents('_posts/0000-00-00-welcome-to-jekyll.markdown', '_posts/0000-00-00-welcome-to-jekyll.markdown'.gsub('0000-00-00', Time.now.strftime("%Y-%m-%d")), "First post")
    name = "#{current_user['login']}.github.io"
    client.edit_repository("#{current_user['login']}/jekyll_default_template", name: name, description: "The personal website of #{client.user.name}. Built using Jekyll and GitHub Pages.", homepage: name)
    redirect_to repositories_path
  end
end
