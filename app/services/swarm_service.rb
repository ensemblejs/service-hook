class SwarmService



  def self.create_game user_name, repo_name, commit_hash
    Docker::Container.create( 'Env' => ["github_user=#{user_name}",
                                        "github_repo=#{repo_name}",
                                        "SERVICE_TAGS=#{repo}.#{user_name}",
                                        "SERVICE_NAME=#{SecureRandom.uuid}"], 
                              'Image' => 'kallikantzaros/ensemblejs',
                              'PortBindings' => { '3000/tcp': [{ "HostPort": "3000" }] },
                              'Labels' => {
                                'com.ensemblejs.user' => user_name,
                                'com.ensemblejs.repo' => repo_name
                              } )

  end

  def self.list_games user_name
    Docker::Container.all(all: true, filters: { label: ["com.ensemblejs.user=#{user_name}"]})
  end
end