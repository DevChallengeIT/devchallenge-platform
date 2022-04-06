Repo::User.where(
    email:     'admin@devchallenge.it'
).first_or_create!(
  full_name: 'Test Admin',
  password:  'password'
)

Repo::Challenge.where(
  title:           'Test Challenge'
).first_or_create!(
  status:          'registration',
  registration_at: Time.now.beginning_of_day,
  start_at:        10.days.from_now.end_of_day,
  finish_at:       15.days.from_now.end_of_day
)

txn_speciality = Repo::Taxonomy.where(title: 'Speciality').first_or_create!
txn_tech = Repo::Taxonomy.where(title: 'Technology').first_or_create!
txn_location = Repo::Taxonomy.where(title: 'Location').first_or_create!

Repo::Taxon.where(title: 'Frontend').first_or_create!(taxonomy_id: txn_speciality.id)
Repo::Taxon.where(title: 'Backend').first_or_create!(taxonomy_id: txn_speciality.id)
Repo::Taxon.where(title: 'DevOps').first_or_create!(taxonomy_id: txn_speciality.id)
Repo::Taxon.where(title: 'QA').first_or_create!(taxonomy_id: txn_speciality.id)
Repo::Taxon.where(title: 'Design').first_or_create!(taxonomy_id: txn_speciality.id)

Repo::Taxon.where(title: 'Ruby').first_or_create!(taxonomy_id: txn_tech.id)
Repo::Taxon.where(title: 'Elxir').first_or_create!(taxonomy_id: txn_tech.id)
Repo::Taxon.where(title: 'JS').first_or_create!(taxonomy_id: txn_tech.id)
Repo::Taxon.where(title: 'HTML').first_or_create!(taxonomy_id: txn_tech.id)
Repo::Taxon.where(title: 'CSS').first_or_create!(taxonomy_id: txn_tech.id)

Repo::Taxon.where(title: 'Online').first_or_create!(taxonomy_id: txn_location.id)
Repo::Taxon.where(title: 'Kyiv').first_or_create!(taxonomy_id: txn_location.id)
Repo::Taxon.where(title: 'Lviv').first_or_create!(taxonomy_id: txn_location.id)
Repo::Taxon.where(title: 'Berlin').first_or_create!(taxonomy_id: txn_location.id)
Repo::Taxon.where(title: 'Barcelona').first_or_create!(taxonomy_id: txn_location.id)
