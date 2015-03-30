task(:spec).clear

desc "Run all specs/features in spec directory"
RSpec::Core::RakeTask.new spec: 'db:test:prepare' do |t|
  t.pattern = './spec/**/*{_spec.rb,.feature}'
end