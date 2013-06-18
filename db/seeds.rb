# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.create(name: 'admin')
Role.create(name: 'reviewer')

g = Group.create(name: 'EPSCoR', acronym: 'EP')

Group.create(name: 'Northern', acronym: 'NTC', parent: g)
Group.create(name: 'Southcentral', acronym: 'SCTC', parent: g )
Group.create(name: 'Southeast', acronym: 'SETC', parent: g)
Group.create(name: 'Cyber Infrastructure', acronym: 'CIS', parent: g)
Group.create(name: 'EOD', acronym: 'EOD', parent: g)
Group.create(name: 'Other', acronym: 'OTHER', parent: g)

[
  'University of Alaska Fairbanks', 'University of Alaska Anchorage', 'University of Alaska Southeast', 
  'Kenai Peninsula College'].each { |m| Mau.create(name: m) }
