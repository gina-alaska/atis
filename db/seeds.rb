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

objectives = ['Climate/Glacier Dynamics', 'Ecosystem Variability', 'Resource Management', 'Other']

ng = Group.create(name: 'Northern', acronym: 'NTC', parent: g)
objectives.each { |m| StrategicObjective.create(name: m, group: ng) }

ng = Group.create(name: 'Southcentral', acronym: 'SCTC', parent: g )
objectives.each { |m| StrategicObjective.create(name: m, group: ng) }

ng = Group.create(name: 'Southeast', acronym: 'SETC', parent: g)
objectives.each { |m| StrategicObjective.create(name: m, group: ng) }

ng = Group.create(name: 'Cyber Infrastructure', acronym: 'CIS', parent: g)
[
  'Resilience and SES Theory (Modeling and Assessments)',
  'Adaptive Capacity', 'Delivery of Research Findings',
  'CANSES', 'Test Case Related Components', 'Other'
].each { |m| StrategicObjective.create(name: m, group: ng) }

ng = Group.create(name: 'EOD', acronym: 'EOD', parent: g)
[ 
  'Education','Outreach','Diversity','EOD South Central Test Case','EOD Northern Test Case',
  'EOD South East Test Case','Other'
].each { |m| StrategicObjective.create(name: m, group: ng) }

ng = Group.create(name: 'Other', acronym: 'OTHER', parent: g)
[ 'Other' ].each { |m| StrategicObjective.create(name: m, group: ng) }


[
  'University of Alaska Fairbanks', 'University of Alaska Anchorage', 'University of Alaska Southeast', 
  'Kenai Peninsula College'
].each { |m| Mau.create(name: m) }
