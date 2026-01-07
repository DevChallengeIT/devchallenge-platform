select
  u.id,
  u.email,
  u.phone_number,
  u.full_name,
  u.time_zone,
  c.title AS challenge
from users u
join members m ON m.user_id = u.id
join challenges c ON c.id = m.challenge_id
where c.slug IN (
  'testing-dev-challenge-xxi-9071f313-7334-43a0-bbfb-7d855874ff4c',
  'frontend-dev-challenge-xxi',
  'backend-dev-challenge-xxi',
  'ui-design-dev-challenge-xxi-8eb6d019-f123-49c3-9711-e8dd7b7b40ed',
  'product-design',
  'macos',
  'testing-lite-dev-challenge-xxi',
  'frontend-lite-dev-challenge-xxi'
)
