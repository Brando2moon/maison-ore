-- ============================================================
-- MAISON ORÉ — Supabase Database Setup
-- Run this in the Supabase SQL Editor
-- ============================================================

-- Profiles table (extends auth.users)
create table if not exists profiles (
  id uuid references auth.users on delete cascade primary key,
  email text,
  full_name text,
  role text default 'customer', -- 'customer', 'vendor', 'admin'
  created_at timestamp default now()
);

-- Vendor applications
create table if not exists vendor_applications (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references profiles(id),
  business_name text,
  contact_name text,
  email text,
  description text,
  category text,
  status text default 'pending', -- 'pending', 'approved', 'rejected'
  created_at timestamp default now()
);

-- Products
create table if not exists products (
  id uuid default gen_random_uuid() primary key,
  vendor_id uuid references profiles(id),
  vendor_name text,
  name text not null,
  description text,
  price decimal(10,2) not null,
  category text,
  image_url text,
  stock integer default 0,
  status text default 'active', -- 'active', 'inactive'
  created_at timestamp default now()
);

-- Orders
create table if not exists orders (
  id uuid default gen_random_uuid() primary key,
  customer_id uuid references profiles(id),
  order_number text unique,
  customer_name text,
  customer_email text,
  shipping_address text,
  total decimal(10,2),
  status text default 'pending',
  items jsonb, -- array of {product_id, name, price, quantity, vendor_id}
  created_at timestamp default now()
);

-- ============================================================
-- Row Level Security
-- ============================================================

alter table profiles enable row level security;
alter table vendor_applications enable row level security;
alter table products enable row level security;
alter table orders enable row level security;

-- Drop existing policies if re-running
drop policy if exists "Users can view own profile" on profiles;
drop policy if exists "Users can update own profile" on profiles;
drop policy if exists "Anyone can view active products" on products;
drop policy if exists "Vendors can manage own products" on products;
drop policy if exists "Customers see own orders" on orders;
drop policy if exists "Customers can create orders" on orders;
drop policy if exists "Anyone can apply" on vendor_applications;
drop policy if exists "Vendors see own application" on vendor_applications;
drop policy if exists "Admin full access profiles" on profiles;
drop policy if exists "Admin full access products" on products;
drop policy if exists "Admin full access orders" on orders;
drop policy if exists "Admin full access vendor_applications" on vendor_applications;

-- Profiles: users can read/update their own
create policy "Users can view own profile" on profiles
  for select using (auth.uid() = id);

create policy "Users can update own profile" on profiles
  for update using (auth.uid() = id);

-- Products: anyone can read active products (public shop)
create policy "Anyone can view active products" on products
  for select using (status = 'active');

-- Vendors can manage their own products
create policy "Vendors can manage own products" on products
  for all using (auth.uid() = vendor_id);

-- Orders: customers see their own orders
create policy "Customers see own orders" on orders
  for select using (auth.uid() = customer_id);

create policy "Customers can create orders" on orders
  for insert with check (auth.uid() = customer_id);

-- Vendor applications: anyone can submit, vendors see their own
create policy "Anyone can apply" on vendor_applications
  for insert with check (true);

create policy "Vendors see own application" on vendor_applications
  for select using (auth.uid() = user_id);

-- ============================================================
-- Auto-create profile on new user signup
-- ============================================================

create or replace function handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, full_name, role)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data->>'full_name',
    coalesce(new.raw_user_meta_data->>'role', 'customer')
  );
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure handle_new_user();

-- ============================================================
-- Seed Data — 6 Sample Products
-- NOTE: These use a placeholder vendor_id. Replace with a real
-- vendor UUID after creating an actual vendor account.
-- ============================================================

-- First insert a placeholder vendor profile (won't conflict with real users)
-- You may need to manually insert this or skip if the UUID conflicts.
-- insert into profiles (id, email, full_name, role)
-- values ('00000000-0000-0000-0000-000000000001', 'seed@maisonore.com', 'Seed Vendor', 'vendor')
-- on conflict (id) do nothing;

insert into products (vendor_id, vendor_name, name, description, price, category, image_url, stock, status)
values
  (
    '00000000-0000-0000-0000-000000000001',
    'Atelier Kōgei',
    'Raku Tea Vessel, Iron-Glazed',
    'A singular piece thrown and fired in Kyōto using traditional raku technique. Iron glaze applied by hand, each result unique. Edition of 12, signed by the maker.',
    1840.00,
    'Ceramics',
    'https://via.placeholder.com/400x500/F3EFE7/0B1F3A?text=Ceramics',
    4,
    'active'
  ),
  (
    '00000000-0000-0000-0000-000000000001',
    'Maison Ferrière',
    'Terracotta Amphora, 42cm',
    'Hand-thrown in Provence from local terracotta clay. A modern amphora form referencing ancient Mediterranean vessels. Made to order, 6-week lead time.',
    620.00,
    'Ceramics',
    'https://via.placeholder.com/400x500/F3EFE7/0B1F3A?text=Ceramics',
    3,
    'active'
  ),
  (
    '00000000-0000-0000-0000-000000000001',
    'Studio Halden',
    'Linen Table Runner, Natural',
    'Woven on a 150-year-old loom in Oslo from sustainably sourced linen. Natural undyed, 240cm × 45cm. Launders beautifully and softens with age.',
    285.00,
    'Textiles',
    'https://via.placeholder.com/400x500/F3EFE7/0B1F3A?text=Textiles',
    12,
    'active'
  ),
  (
    '00000000-0000-0000-0000-000000000001',
    'Herrera & Ono',
    'Brass Floor Lamp, Articulated',
    'Sculpted brass with a matte patina finish. Fully articulated shade rotates 360°. Includes a hand-braided textile cord. Designed in Marrakech.',
    1240.00,
    'Lighting',
    'https://via.placeholder.com/400x500/F3EFE7/0B1F3A?text=Lighting',
    6,
    'active'
  ),
  (
    '00000000-0000-0000-0000-000000000001',
    'Atelier Kōgei',
    'Kintsukuroi Ring, 18k Gold',
    'Sterling silver band with kintsugi-style 18k gold repair lines. Each ring is unique — no two are identical. Inspired by the Japanese art of repairing with gold.',
    480.00,
    'Jewelry',
    'https://via.placeholder.com/400x500/F3EFE7/0B1F3A?text=Jewelry',
    8,
    'active'
  ),
  (
    '00000000-0000-0000-0000-000000000001',
    'Maison Ferrière',
    'Cast Iron Paperweight, River Stone',
    'Cast iron paperweight in the form of a river stone. Each one poured and hand-finished in a small foundry in Provence. Substantial and quiet on a desk.',
    195.00,
    'Objets',
    'https://via.placeholder.com/400x500/F3EFE7/0B1F3A?text=Objets',
    15,
    'active'
  )
on conflict do nothing;
