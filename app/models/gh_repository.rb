# A proxy class to Repositories with some custom methods
class GHRepository < GHProxy
  attr_reader :config, :client

  def initialize(client, target = nil)
    @client = client
    @target = target || @client.repositories.first
  end

  def to_param
    id
  end

  def jekyll?
    !config.blank?
  end

  def contents(path = '/')
    @contents ||= {}
    @contents[path] = @client.contents(id, path: path)
  end

  def config
    @config_file ||= contents('/').map(&:path).include?('_config.yml')
    if @config_file
      @config ||= @client.contents(id, path: '/_config.yml')
      SafeYAML.load(GHFile.new(@config).content)
    else
      false
    end
  end

  def config?
    @config_file ||= contents('/').map(&:path).include?('_config.yml')
  end

  def post_metadata
    return false unless jekyll?
    @post_metadata ||= (config.try(:[], 'kissmyblog') || config.try(:[], 'prose')).try(:[], 'metadata').try(:[], '_posts') || []
  end

  def posts
    @posts ||= contents('/_posts')
  end

  def drafts
    @drafts ||= if contents('/').map(&:path).include?('_drafts')
      contents('/_drafts')
    else
      []
    end
  end

  def media_path
    @media_path ||= (config.try(:[], 'kissmyblog') || config.try(:[], 'prose')).try(:[], 'media') || 'assets/img'
  end

  def images
    @images ||= contents(media_path) if media_path
  end

  def commits
    @commits ||= @client.commits(full_name, 'master')
  end

  def last_commit
    @last_commit ||= commits.first
  end

  def get_post(filename)
    GHPost.new(contents(File.join('/_posts', File.basename(filename)))).tap do |p|
      p.repository = self
    end
  end

  def get_draft(filename)
    GHDraft.new(contents(File.join('/_drafts', File.basename(filename)))).tap do |p|
      p.repository = self
    end
  end

  def get_image(filename)
    # FIXME: Be nice with GitHub, don't load content!!
    GHImage.new(images.find{|i| i.path == File.join(media_path, filename)}).tap do |i|
      i.repository = self
    end
  end

  def create_contents(path, message, content)
    #TOOO: Check SHA and if content has changed before saving
    client.create_contents(full_name, path, message, content)
  end

  def update_contents(path, message, sha, content)
    #TOOO: Check SHA and if content has changed before saving
    client.update_contents(full_name, path, message, sha, content)
  end

  def delete_contents(path, message, sha)
    client.delete_contents(full_name, path, message, sha)
  end

  def move_contents(path, new_path, message)
    tree = client.tree(full_name, last_commit.sha, recursive: true)
    file = tree.tree.find{|n| n.path == path}

    if file
      # We'll need to create a new directory tree without the moved file
      tree_to_update = tree.tree.find{|n| n.path == File.dirname(path)}

      file.path = new_path

      # Get all the remaining files in the directory
      content_for_update = []
      tree.tree.delete_if do |n|
        if n.path =~ Regexp.new("#{File.dirname(path)}\/[^\/]*")
          n.path = File.basename(n.path)
          content_for_update << n
          true
        end
      end

      # Create a tree with the remaining files and update the old directory sha to point to the new tree
      new_tree = client.create_tree(full_name, content_for_update)
      tree_to_update.sha = new_tree.sha

      full_tree = client.create_tree(full_name, tree.tree)
      commit    = client.create_commit(full_name, message, full_tree.sha, last_commit.sha)
      client.update_branch(full_name, 'master', commit.sha)
    end
  end
end
