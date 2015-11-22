# ref: https://github.com/grackorg/grack

require 'grack/app'
require 'grack/git_adapter'

repos_root = '/data/repos'

config = {
  :root => repos_root,
  :allow_push => true,
  :allow_pull => true,
  :git_adapter_factory => ->{ Grack::GitAdapter.new }
}

run Grack::App.new(config)
