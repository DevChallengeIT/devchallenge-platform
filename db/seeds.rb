Repo::User.where(
  email: 'admin@devchallenge.it'
).first_or_create(
  full_name: 'Test Admin',
  password:  'password'
)

# === CHALLENGES ==============================================================
be_challenge = Repo::Challenge.where(
  title:           'Backend Challenge'
).first_or_create(
  status:          'ready',
  registration_at: Time.now.beginning_of_day,
  start_at:        10.days.from_now.end_of_day,
  finish_at:       40.days.from_now.end_of_day
)

fe_challenge = Repo::Challenge.where(
  title:           'Frontend Challenge'
).first_or_create(
  status:          'ready',
  registration_at: Time.now.beginning_of_day + 1.day,
  start_at:        10.days.from_now.end_of_day + 1.day,
  finish_at:       40.days.from_now.end_of_day + 1.day
)

# === TASKS ===================================================================
be_task_1 = Repo::Task.where(
  title:           'Qualification'
).first_or_create(
  challenge:   be_challenge,
  start_at:    be_challenge.start_at + 1.day,
  submit_at:   be_challenge.start_at + 20.days,
  result_at:   be_challenge.start_at + 21.day,
  description: 'Some description to make this task done'
)

be_task_2 = Repo::Task.where(
  title:           'Online'
).first_or_create(
  challenge:   be_challenge,
  start_at:    be_task_1.result_at + 5.days,
  submit_at:   be_task_1.result_at + 12.days,
  result_at:   be_task_1.result_at + 13.days,
  dependent_task: be_task_1,
  description: 'Some description to make this task done'
)

be_task_3 = Repo::Task.where(
  title:           'Final'
).first_or_create(
  challenge:      be_challenge,
  description:    'This is extra task which depends on the first one',
  dependent_task: be_task_2,
  start_at:       be_task_2.result_at + 5.days,
  submit_at:      be_task_2.result_at + 6.days,
  result_at:      be_task_2.result_at + 7.days,
)

fe_task_1 = Repo::Task.where(
  title:           'FE Qualification'
).first_or_create(
  challenge:   fe_challenge,
  start_at:    fe_challenge.start_at + 1.day,
  submit_at:   fe_challenge.start_at + 20.days,
  result_at:   fe_challenge.start_at + 21.day,
  description: 'Some description to make this task done'
)

fe_task_2 = Repo::Task.where(
  title:           'FE Online'
).first_or_create(
  challenge:      fe_challenge,
  description:    'This is extra task which depends on the first one',
  dependent_task: fe_task_1,
  start_at:       fe_task_1.result_at + 6.days,
  submit_at:      fe_task_1.result_at + 7.days,
  result_at:      fe_task_1.result_at + 8.days,
)

# === MEMBERS =================================================================
participant = Repo::User.where(
  email:     'participant@devchallenge.it'
).first_or_create(
  full_name: 'Test Participant',
  password:  'password'
)

participant2 = Repo::User.where(
  email:     'participant2@devchallenge.it'
).first_or_create(
  full_name: 'Test2 Participant',
  password:  'password'
)

judge = Repo::User.where(
  email:     'judge@devchallenge.it'
).first_or_create(
  full_name: 'Test Judge',
  password:  'password'
)

participant_member_1 = Repo::Member.where(
  challenge: be_challenge,
  user: participant,
).first_or_create

participant_member_2 = Repo::Member.where(
  challenge: be_challenge,
  user: participant2,
).first_or_create

judge_member = Repo::Member.where(
  challenge: be_challenge,
  user: judge,
  role: :judge
).first_or_create

# === CRITERIA ================================================================
be_task_1_criterium_1 = Repo::TaskCriterium.where(
  title: "Passed",
  max_value: 1,
  task:   be_task_1
).first_or_create

be_task_2_criterium_1 = Repo::TaskCriterium.where(
  title: "Code quality",
  max_value: 10,
  task:   be_task_2
).first_or_create

be_task_2_criterium_2 = Repo::TaskCriterium.where(
  title: "API Implementation",
  max_value: 15,
  task:   be_task_2
).first_or_create

be_task_2_criterium_3 = Repo::TaskCriterium.where(
  title: "Unit tests",
  max_value: 15,
  task:   be_task_2
).first_or_create

be_task_2_criterium_4 = Repo::TaskCriterium.where(
  title: "Performance",
  max_value: 20,
  task:   be_task_2
).first_or_create

be_task_2_criterium_5 = Repo::TaskCriterium.where(
  title: "Overall impression",
  max_value: 20,
  task:   be_task_2
).first_or_create

be_task_3_criterium_1 = Repo::TaskCriterium.where(
  title: "Code quality",
  max_value: 10,
  task:   be_task_3
).first_or_create

be_task_3_criterium_2 = Repo::TaskCriterium.where(
  title: "API Implementation",
  max_value: 15,
  task:   be_task_3
).first_or_create

be_task_3_criterium_3 = Repo::TaskCriterium.where(
  title: "Unit tests",
  max_value: 15,
  task:   be_task_3
).first_or_create

be_task_3_criterium_4 = Repo::TaskCriterium.where(
  title: "Performance",
  max_value: 20,
  task:   be_task_3
).first_or_create

be_task_3_criterium_5 = Repo::TaskCriterium.where(
  title: "Overall impression",
  max_value: 20,
  task:   be_task_3
).first_or_create

# === SUBMISSIONS =============================================================
task_1_submission_1 = Repo::TaskSubmission.where(
  task:   be_task_1,
  member: participant_member_1
).first_or_create(notes: "Submitted: '#{be_task_1.title}' task")

task_2_submission_1 = Repo::TaskSubmission.where(
  task:   be_task_2,
  member: participant_member_1
).first_or_create(notes: "Submitted: '#{be_task_2.title}' task")

task_3_submission_1 = Repo::TaskSubmission.where(
  task:   be_task_3,
  member: participant_member_1
).first_or_create(notes: "Submitted: '#{be_task_3.title}' task")

task_1_submission_2 = Repo::TaskSubmission.where(
  task:   be_task_1,
  member: participant_member_2
).first_or_create(notes: "Submitted: '#{be_task_1.title}' task")

task_2_submission_2 = Repo::TaskSubmission.where(
  task:   be_task_2,
  member: participant_member_2
).first_or_create(notes: "Submitted: '#{be_task_2.title}' task")

task_3_submission_2 = Repo::TaskSubmission.where(
  task:   be_task_3,
  member: participant_member_2
).first_or_create(notes: "Submitted: '#{be_task_3.title}' task")

submissions_hash = [
  {
    submission: task_1_submission_1,
    file_name: 'submission.zip'
  },
  {
    submission: task_2_submission_1,
    file_name: 'submission2.zip'
  },
  {
    submission: task_3_submission_1,
    file_name: 'submission3.zip'
  },
  {
    submission: task_1_submission_2,
    file_name: 'submission_2-1.zip'
  },
  {
    submission: task_2_submission_2,
    file_name: 'submission_2-2.zip'
  },
  {
    submission: task_3_submission_2,
    file_name: 'submission_2-3.zip'
  }
]

submissions_hash.each do |submission_hash|
   file_path = Rails.root.join('spec', 'support', 'assets', submission_hash[:file_name])
   file = File.open(file_path)

   submission_hash[:submission].zip_file.attach(io: file, filename: "submitted #{submission_hash[:file_name]} file")
end

# === ASSESSMENTS =============================================================
# === FIRST PARICIPANT
Repo::TaskAssessment.where(
  judge: judge_member,
  task_submission: task_1_submission_1,
  task_criterium: be_task_1_criterium_1
).first_or_create(value: 1, comment: 'Passed!')

Repo::TaskAssessment.where(
  judge: judge_member,
  task_submission: task_2_submission_1,
  task_criterium: be_task_2_criterium_1
).first_or_create(value: 10, comment: 'Nice job!!!')

Repo::TaskAssessment.where(
  judge: judge_member,
  task_submission: task_2_submission_1,
  task_criterium: be_task_2_criterium_2
).first_or_create(value: 15, comment: 'Good job!!!')

Repo::TaskAssessment.where(
  judge: judge_member,
  task_submission: task_2_submission_1,
  task_criterium: be_task_2_criterium_3
).first_or_create(value: 20, comment: 'Excellent')

Repo::TaskAssessment.where(
  judge: judge_member,
  task_submission: task_2_submission_1,
  task_criterium: be_task_2_criterium_4
).first_or_create(value: 20, comment: 'OMG! It is so nice!')

Repo::TaskAssessment.where(
  judge: judge_member,
  task_submission: task_2_submission_1,
  task_criterium: be_task_2_criterium_5
).first_or_create(value: 20, comment: 'I want kids from this guy!')

# === SECOND PARICIPANT
Repo::TaskAssessment.where(
  judge: judge_member,
  task_submission: task_1_submission_2,
  task_criterium: be_task_1_criterium_1
).first_or_create(value: 1, comment: 'Passed!')

Repo::TaskAssessment.where(
  judge: judge_member,
  task_submission: task_2_submission_2,
  task_criterium: be_task_2_criterium_1
).first_or_create(value: 5, comment: 'OK')

Repo::TaskAssessment.where(
  judge: judge_member,
  task_submission: task_2_submission_2,
  task_criterium: be_task_2_criterium_2
).first_or_create(value: 7, comment: 'OK too')

Repo::TaskAssessment.where(
  judge: judge_member,
  task_submission: task_2_submission_2,
  task_criterium: be_task_2_criterium_3
).first_or_create(value: 10, comment: 'So-so')

Repo::TaskAssessment.where(
  judge: judge_member,
  task_submission: task_2_submission_2,
  task_criterium: be_task_2_criterium_5
).first_or_create(value: 2, comment: 'No comments')

# === TAXONOMIES & TAXONS =====================================================
txn_speciality = Repo::Taxonomy.where(title: 'Specialty').first_or_create
txn_tech = Repo::Taxonomy.where(title: 'Technology').first_or_create
txn_location = Repo::Taxonomy.where(title: 'Location').first_or_create

Repo::TaxonomyRepo.create(repo: :challenges, taxonomy: txn_location)
Repo::TaxonomyRepo.create(repo: :challenges, taxonomy: txn_speciality)
Repo::TaxonomyRepo.create(repo: :challenges, taxonomy: txn_tech)

Repo::Taxon.where(title: 'Frontend').first_or_create(taxonomy_id: txn_speciality.id)
tax_backend = Repo::Taxon.where(title: 'Backend').first_or_create(taxonomy_id: txn_speciality.id)
Repo::Taxon.where(title: 'DevOps').first_or_create(taxonomy_id: txn_speciality.id)
Repo::Taxon.where(title: 'QA').first_or_create(taxonomy_id: txn_speciality.id)
Repo::Taxon.where(title: 'Design').first_or_create(taxonomy_id: txn_speciality.id)

tax_ruby = Repo::Taxon.where(title: 'Ruby').first_or_create(taxonomy_id: txn_tech.id)
Repo::Taxon.where(title: 'Elixir').first_or_create(taxonomy_id: txn_tech.id)
Repo::Taxon.where(title: 'JS').first_or_create(taxonomy_id: txn_tech.id)
Repo::Taxon.where(title: 'HTML').first_or_create(taxonomy_id: txn_tech.id)
Repo::Taxon.where(title: 'CSS').first_or_create(taxonomy_id: txn_tech.id)

tax_online = Repo::Taxon.where(title: 'Online').first_or_create(taxonomy_id: txn_location.id)
Repo::Taxon.where(title: 'Kyiv').first_or_create(taxonomy_id: txn_location.id)
Repo::Taxon.where(title: 'Lviv').first_or_create(taxonomy_id: txn_location.id)
Repo::Taxon.where(title: 'Berlin').first_or_create(taxonomy_id: txn_location.id)
Repo::Taxon.where(title: 'Barcelona').first_or_create(taxonomy_id: txn_location.id)

Repo::TaxonEntity.create(taxon: tax_backend, entity: be_challenge)
Repo::TaxonEntity.create(taxon: tax_ruby, entity: be_challenge)
Repo::TaxonEntity.create(taxon: tax_online, entity: be_challenge)
