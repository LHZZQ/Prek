begin;

select plan(6);


insert into public."Profiles" (id, email)
values
  ('11111111-1111-1111-1111-111111111111', 'user-a@example.com'),
  ('22222222-2222-2222-2222-222222222222', 'user-b@example.com');

insert into public."Gratitude Entries" (id, user_id, mood, text)
values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'happy', 'entry from user A'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '22222222-2222-2222-2222-222222222222', 'calm', 'entry from user B');


create or replace function pg_temp.try_insert_entry(target_user_id uuid)
returns boolean
language plpgsql
as $$
begin
  insert into public."Gratitude Entries" (user_id, mood, text)
  values (target_user_id, 'test', 'created in test');

  return true;
exception
  when others then
    return false;
end;
$$;

/* Pretend the authenticated user is user A. */
select set_config(
  'request.jwt.claim.sub',
  '11111111-1111-1111-1111-111111111111',
  true
);
set local role authenticated;

select is(
  (select count(*)::int from public."Profiles"),
  1,
  'authenticated user can only see their own profile'
);

select is(
  (select count(*)::int from public."Gratitude Entries"),
  1,
  'authenticated user can only see their own gratitude entry'
);

select is(
  (
    select email
    from public."Profiles"
    where id = '11111111-1111-1111-1111-111111111111'
  ),
  'user-a@example.com',
  'user A can read their own profile row'
);

select is(
  (
    select count(*)::int
    from public."Profiles"
    where id = '22222222-2222-2222-2222-222222222222'
  ),
  0,
  'user A cannot read user B profile row'
);

select ok(
  pg_temp.try_insert_entry('11111111-1111-1111-1111-111111111111'),
  'user A can insert an entry for themselves'
);

select ok(
  not pg_temp.try_insert_entry('22222222-2222-2222-2222-222222222222'),
  'user A cannot insert an entry for another user'
);

reset role;

select * from finish();

rollback;
