# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def fixtures(name)
  Dir.glob(Rails.root.join 'db', 'fixtures', name, '**', '*.yml')
end

rig_store = Rig::Store.build
rig_files = fixtures 'rigs'
rig_files.each do |f|
  attrs = YAML.load_file f
  next if rig_store.find_by_name(attrs['name'])
  form = Rig::Form.new(attrs)
  r = rig_store.create(form)
  if r.persisted?
    puts "Adding #{attrs['name']}"
  else
    puts "Could not add #{attrs['name']}"
  end
end
