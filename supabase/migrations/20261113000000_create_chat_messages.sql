-- Shared chat room messages for chat.html.
-- Anyone (anon or signed-in) can read and post. No one can edit or delete.

create table public.chat_messages (
  id bigint generated always as identity primary key,
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

create policy "Anyone can post chat messages"
  on public.chat_messages for insert
  to anon, authenticated
  with check (true);

alter publication supabase_realtime add table public.chat_messages;
