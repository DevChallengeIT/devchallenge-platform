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

Repo::Taxonomy.where(title: 'Speciality').first_or_create!
Repo::Taxonomy.where(title: 'Technology').first_or_create!
Repo::Taxonomy.where(title: 'Location').first_or_create!