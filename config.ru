require 'grack'

config = {
  :project_root => '[REPOS_PATH]',
  :upload_pack => true,
  :receive_pack => true,
}

server = Grack::Server.new(config)

run server