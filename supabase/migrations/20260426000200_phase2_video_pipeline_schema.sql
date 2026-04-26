-- Phase 2 schema for uploaded service videos, transcript chunks, sections,
-- clip candidates, and render jobs.

create table if not exists public.videos (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  status text not null default 'uploaded' check (
    status in ('uploaded', 'processing', 'transcribed', 'analyzed', 'ready', 'failed')
  ),
  original_file_key text not null,
  duration_seconds numeric(10, 3) check (duration_seconds is null or duration_seconds >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.transcript_segments (
  id uuid primary key default gen_random_uuid(),
  video_id uuid not null references public.videos(id) on delete cascade,
  start_time numeric(10, 3) not null check (start_time >= 0),
  end_time numeric(10, 3) not null check (end_time > start_time),
  text text not null,
  speaker_label text,
  confidence numeric(5, 4) check (confidence is null or (confidence >= 0 and confidence <= 1))
);

create table if not exists public.service_sections (
  id uuid primary key default gen_random_uuid(),
  video_id uuid not null references public.videos(id) on delete cascade,
  type text not null check (
    type in ('pre_service', 'worship', 'announcements', 'sermon', 'altar_call', 'prayer', 'outro', 'unknown')
  ),
  start_time numeric(10, 3) not null check (start_time >= 0),
  end_time numeric(10, 3) not null check (end_time > start_time),
  confidence numeric(5, 4) not null check (confidence >= 0 and confidence <= 1),
  reason text not null
);

create table if not exists public.clip_candidates (
  id uuid primary key default gen_random_uuid(),
  video_id uuid not null references public.videos(id) on delete cascade,
  start_time numeric(10, 3) not null check (start_time >= 0),
  end_time numeric(10, 3) not null check (end_time > start_time),
  title text not null,
  summary text not null,
  hook_score numeric(5, 2) not null check (hook_score >= 0 and hook_score <= 100),
  standalone_score numeric(5, 2) not null check (standalone_score >= 0 and standalone_score <= 100),
  emotional_score numeric(5, 2) not null check (emotional_score >= 0 and emotional_score <= 100),
  theology_clarity_score numeric(5, 2) not null check (theology_clarity_score >= 0 and theology_clarity_score <= 100),
  shareability_score numeric(5, 2) not null check (shareability_score >= 0 and shareability_score <= 100),
  clean_ending_score numeric(5, 2) not null check (clean_ending_score >= 0 and clean_ending_score <= 100),
  overall_score numeric(5, 2) not null check (overall_score >= 0 and overall_score <= 100),
  reason text not null,
  status text not null default 'suggested' check (
    status in ('suggested', 'approved', 'rejected', 'rendered')
  ),
  created_at timestamptz not null default now()
);

-- Rebuild render_jobs to align with clip_candidates-driven rendering.
drop table if exists public.render_jobs;

create table public.render_jobs (
  id uuid primary key default gen_random_uuid(),
  clip_candidate_id uuid not null references public.clip_candidates(id) on delete cascade,
  status text not null default 'queued' check (status in ('queued', 'processing', 'completed', 'failed', 'canceled')),
  progress integer not null default 0 check (progress >= 0 and progress <= 100),
  output_file_key text,
  error_message text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_transcript_segments_video_id on public.transcript_segments(video_id);
create index if not exists idx_service_sections_video_id on public.service_sections(video_id);
create index if not exists idx_clip_candidates_video_id on public.clip_candidates(video_id);
create index if not exists idx_clip_candidates_status on public.clip_candidates(status);
create index if not exists idx_render_jobs_clip_candidate_id on public.render_jobs(clip_candidate_id);
create index if not exists idx_render_jobs_status on public.render_jobs(status);
