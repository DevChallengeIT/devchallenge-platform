Repo::User.where(
    email:     'admin@devchallenge.it'
).first_or_create!(
  full_name: 'Test Admin',
  password:  'password'
)

challenge = Repo::Challenge.where(
  title:           'Test Challenge'
).first_or_create!(
  status:          'ready',
  registration_at: Time.now.beginning_of_day,
  start_at:        10.days.from_now.end_of_day,
  finish_at:       15.days.from_now.end_of_day
)

first_task = Repo::Task.where(
  title:           'First Task'
).first_or_create!(
  challenge:   challenge,
  start_at:    challenge.start_at + 1.day,
  description: 'Some description to make this task done'
)

second_task = Repo::Task.where(
  title:           'Second Task'
).first_or_create!(
  challenge:      first_task.challenge,
  description:    'This is extra task wich depends on the first one',
  dependent_task: first_task,
  start_at:       first_task.start_at + 2.days,
)

# TODO: need to add member!
Repo::TaskSubmission.where(
  task:   first_task,
  member: member
).first_or_create!(notes: "Submitted: '#{first_task.title}' task")

Repo::TaskSubmission.where(
  task:   second_task,
  member: member
).first_or_create!(notes: "Submitted: '#{second_task.title}' task")

txn_speciality = Repo::Taxonomy.where(title: 'Speciality').first_or_create!
txn_tech = Repo::Taxonomy.where(title: 'Technology').first_or_create!
txn_location = Repo::Taxonomy.where(title: 'Location').first_or_create!

Repo::TaxonomyRepo.create(repo: :challenges, taxonomy: txn_location)
Repo::TaxonomyRepo.create(repo: :challenges, taxonomy: txn_speciality)
Repo::TaxonomyRepo.create(repo: :challenges, taxonomy: txn_tech)

Repo::Taxon.where(title: 'Frontend').first_or_create!(taxonomy_id: txn_speciality.id)
tax_backend = Repo::Taxon.where(title: 'Backend').first_or_create!(taxonomy_id: txn_speciality.id)
Repo::Taxon.where(title: 'DevOps').first_or_create!(taxonomy_id: txn_speciality.id)
Repo::Taxon.where(title: 'QA').first_or_create!(taxonomy_id: txn_speciality.id)
Repo::Taxon.where(title: 'Design').first_or_create!(taxonomy_id: txn_speciality.id)

tax_ruby = Repo::Taxon.where(title: 'Ruby').first_or_create!(taxonomy_id: txn_tech.id)
Repo::Taxon.where(title: 'Elixir').first_or_create!(taxonomy_id: txn_tech.id)
Repo::Taxon.where(title: 'JS').first_or_create!(taxonomy_id: txn_tech.id)
Repo::Taxon.where(title: 'HTML').first_or_create!(taxonomy_id: txn_tech.id)
Repo::Taxon.where(title: 'CSS').first_or_create!(taxonomy_id: txn_tech.id)

tax_online = Repo::Taxon.where(title: 'Online').first_or_create!(taxonomy_id: txn_location.id)
Repo::Taxon.where(title: 'Kyiv').first_or_create!(taxonomy_id: txn_location.id)
Repo::Taxon.where(title: 'Lviv').first_or_create!(taxonomy_id: txn_location.id)
Repo::Taxon.where(title: 'Berlin').first_or_create!(taxonomy_id: txn_location.id)
Repo::Taxon.where(title: 'Barcelona').first_or_create!(taxonomy_id: txn_location.id)

Repo::TaxonEntity.create(taxon: tax_backend, entity: challenge)
Repo::TaxonEntity.create(taxon: tax_ruby, entity: challenge)
Repo::TaxonEntity.create(taxon: tax_online, entity: challenge)
