class RepositoriesController < ApplicationController
  before_action :authorize

  def index
    @repositories = client.repositories.map{ |r| GHRepository.new(@client, r) }
  end
end
