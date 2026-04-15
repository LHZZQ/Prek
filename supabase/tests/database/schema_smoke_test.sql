begin;

select plan(10);

select has_table('public', 'Profiles', 'Profiles table should exist');
select has_table('public', 'Gratitude Entries', 'Gratitude Entries table should exist');

select has_column('public', 'Profiles', 'id', 'Profiles.id should exist');
select has_column('public', 'Profiles', 'email', 'Profiles.email should exist');
select has_column('public', 'Gratitude Entries', 'user_id', 'Gratitude Entries.user_id should exist');
select has_column('public', 'Gratitude Entries', 'mood', 'Gratitude Entries.mood should exist');
select has_column('public', 'Gratitude Entries', 'audio_path', 'Gratitude Entries.audio_path should exist');

select is(
  (select count(*)::int
   from pg_policies
   where schemaname = 'public'
     and tablename = 'Profiles'
     and policyname = 'Users can view their own profiles'),
  1,
  'Profiles view policy'
);

select is(
  (select count(*)::int
   from pg_policies
   where schemaname = 'public'
     and tablename = 'Profiles'
     and policyname = 'Users can update their own profiles'),
  1,
  'Profiles update policy'
);

select is(
  (select count(*)::int
   from pg_policies
   where schemaname = 'public'
     and tablename = 'Gratitude Entries'
     and policyname = 'Users can view their own entries'),
  1,
  'Gratitude Entries view policy'
);

select * from finish();

rollback;
