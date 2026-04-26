-- Initial baseline schema for pipeline orchestration.

create extension if not exists pgcrypto;

create table if not exists public.services (
  id uuid primary key default gen_random_uuid(),
  external_ref text,
  title text not null,
  source_video_url text,
  scheduled_at timestamptz,
  status text not null default 'pending' check (status in ('pending', 'processing', 'ready', 'failed')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.transcripts (
  id uuid primary key default gen_random_uuid(),
  service_id uuid not null references public.services(id) on delete cascade,
  language_code text not null default 'en',
  provider text,
  status text not null default 'queued' check (status in ('queued', 'processing', 'completed', 'failed')),
  raw_text text,
  word_timestamps jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.clips (
  id uuid primary key default gen_random_uuid(),
  service_id uuid not null references public.services(id) on delete cascade,
  transcript_id uuid references public.transcripts(id) on delete set null,
  title text,
  start_second numeric(10, 3) not null,
  end_second numeric(10, 3) not null,
  score numeric(5, 2),
  status text not null default 'draft' check (status in ('draft', 'selected', 'rejected', 'rendering', 'rendered', 'failed')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (end_second > start_second)
);

create table if not exists public.render_jobs (
  id uuid primary key default gen_random_uuid(),
  clip_id uuid not null references public.clips(id) on delete cascade,
  preset text not null default 'vertical_1080x1920',
  status text not null default 'queued' check (status in ('queued', 'processing', 'completed', 'failed', 'canceled')),
  output_url text,
  error_message text,
  started_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_transcripts_service_id on public.transcripts(service_id);
create index if not exists idx_clips_service_id on public.clips(service_id);
create index if not exists idx_clips_transcript_id on public.clips(transcript_id);
create index if not exists idx_render_jobs_clip_id on public.render_jobs(clip_id);
