-- Chat room messages for chat.html, stored in the AuthorOS Write project.
-- Anyone can read. Only signed-in users can post, and only as themselves.
-- Nobody can edit or delete messages.

create table public.chat_messages (
  id bigint generated always as identity primary key,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  author text not null check (char_length(author) between 1 and 30),
  body text not null check (char_length(body) between 1 and 500),
  created_at timestamptz not null default now()
);

create index chat_messages_created_at_idx on public.chat_messages (created_at desc);

alter table public.chat_messages enable row level security;

create policy "Anyone can read chat messages"
  on public.chat_messages for select
  to anon, authenticated
  using (true);

create policy "Signed-in users can post as themselves"
  on public.chat_messages for insert
  to authenticated
  with check (user_id = auth.uid());
