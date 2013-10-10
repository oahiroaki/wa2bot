%w(bot character configure post search).each do |path|
  require File.expand_path('../wa2bot/' + path, __FILE__)
end
