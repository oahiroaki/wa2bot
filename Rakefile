require 'rake/testtask'

Rake::TestTask.new do |t|
  require 'minitest/pride'
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end
