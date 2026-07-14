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
-- Seed Data — 4 Vendor Profiles + 20 Products w/ Real Images
-- ============================================================

insert into profiles (id, email, full_name, role)
values
  ('00000000-0000-0000-0000-000000000001', 'seed@maisonore.com', 'Atelier Kogei', 'vendor'),
  ('00000000-0000-0000-0000-000000000002', 'studio.halden@maisonore.com', 'Studio Halden', 'vendor'),
  ('00000000-0000-0000-0000-000000000003', 'herrera.ono@maisonore.com', 'Herrera & Ono', 'vendor'),
  ('00000000-0000-0000-0000-000000000004', 'atelier.ferriere@maisonore.com', 'Atelier Ferriere', 'vendor')
on conflict (id) do nothing;

insert into products (vendor_id, vendor_name, name, description, price, category, image_url, stock, status)
values
  ('00000000-0000-0000-0000-000000000001', 'Atelier Kogei', 'Raku Tea Vessel, Iron-Glazed', 'A singular piece thrown and fired in Kyoto using traditional raku technique. Iron glaze applied by hand, each result unique. Edition of 12, signed by the maker.', 1840.00, 'Ceramics', 'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=800&q=80', 4, 'active'),
  ('00000000-0000-0000-0000-000000000001', 'Atelier Kogei', 'Wabi-Sabi Sake Cup Set', 'A set of four hand-thrown sake cups in matte earth tones. Each cup varies slightly — a deliberate embrace of imperfection. Fired at 1280C in a wood kiln.', 195.00, 'Ceramics', 'https://images.unsplash.com/photo-1608755728617-aefab37d2edd?w=800&q=80', 6, 'active'),
  ('00000000-0000-0000-0000-000000000001', 'Atelier Kogei', 'Celadon Bud Vase, Tall', 'Wheel-thrown porcelain with a classic celadon glaze. Stands 32cm. The glaze pools beautifully at the base, showing depth of colour from pale sky to deep jade.', 340.00, 'Ceramics', 'https://images.unsplash.com/photo-1612198273689-b4f5b8f0f3b3?w=800&q=80', 5, 'active'),
  ('00000000-0000-0000-0000-000000000001', 'Atelier Kogei', 'Kintsukuroi Ring, 18k Gold', 'Sterling silver band with kintsugi-style 18k gold repair lines. Each ring is unique. Inspired by the Japanese art of repairing with gold.', 480.00, 'Jewelry', 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=800&q=80', 8, 'active'),
  ('00000000-0000-0000-0000-000000000001', 'Atelier Kogei', 'Terracotta Amphora, 42cm', 'Hand-thrown in Provence from local terracotta clay. A modern amphora form referencing ancient Mediterranean vessels. Made to order, 6-week lead time.', 620.00, 'Ceramics', 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=800&q=80', 3, 'active'),
  ('00000000-0000-0000-0000-000000000002', 'Studio Halden', 'Linen Table Runner, Natural', 'Woven on a 150-year-old loom in Oslo from sustainably sourced linen. Natural undyed, 240cm x 45cm. Launders beautifully and softens with age.', 285.00, 'Textiles', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80', 12, 'active'),
  ('00000000-0000-0000-0000-000000000002', 'Studio Halden', 'Merino Throw, Storm Grey', 'Single-ply merino wool throw woven in the Halden workshop. 140cm x 200cm. Warm without weight. Edges hand-finished with a simple rolled hem.', 320.00, 'Textiles', 'https://images.unsplash.com/photo-1585128792020-803d29415281?w=800&q=80', 9, 'active'),
  ('00000000-0000-0000-0000-000000000002', 'Studio Halden', 'Oak Stool, Low Form', 'Solid white oak, hand-planed and finished with a single coat of raw linseed oil. 38cm seat height. No metal hardware — mortise and tenon joinery only.', 680.00, 'Furniture', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800&q=80', 3, 'active'),
  ('00000000-0000-0000-0000-000000000002', 'Studio Halden', 'Indigo Linen Cushion Cover', 'Hand-dyed with natural indigo in small batches. 50cm x 50cm. Each cover varies in shade. Insert not included.', 145.00, 'Textiles', 'https://images.unsplash.com/photo-1519710164239-da123dc03ef4?w=800&q=80', 14, 'active'),
  ('00000000-0000-0000-0000-000000000002', 'Studio Halden', 'Walnut Dining Chair', 'Solid walnut frame with a hand-woven rush seat. Stackable. Designed in Oslo, made in small batches of 12. Lead time 4 weeks.', 1100.00, 'Furniture', 'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=800&q=80', 4, 'active'),
  ('00000000-0000-0000-0000-000000000003', 'Herrera & Ono', 'Brass Floor Lamp, Articulated', 'Sculpted brass with a matte patina finish. Fully articulated shade rotates 360 degrees. Includes a hand-braided textile cord. Designed in Marrakech.', 1240.00, 'Lighting', 'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?w=800&q=80', 6, 'active'),
  ('00000000-0000-0000-0000-000000000003', 'Herrera & Ono', 'Hammered Brass Pendant', 'Hand-hammered raw brass pendant. 28cm diameter. Each piece is hammered individually — no two have the same pattern of light. Canopy and 2m cable included.', 890.00, 'Lighting', 'https://images.unsplash.com/photo-1513506003901-1e6a35ac5891?w=800&q=80', 4, 'active'),
  ('00000000-0000-0000-0000-000000000003', 'Herrera & Ono', 'Bronze Incense Holder', 'Lost-wax cast bronze. Holds a single stick at 45 degrees, ash falls onto the sculpted base. 18cm long. Develops a rich patina with use.', 165.00, 'Objets', 'https://images.unsplash.com/photo-1602523961358-f9f03dd557db?w=800&q=80', 11, 'active'),
  ('00000000-0000-0000-0000-000000000003', 'Herrera & Ono', 'Moroccan Berber Rug, 120x180', 'Hand-knotted in the Atlas Mountains by a collective of women weavers. High-low pile in undyed natural wool — ivory, camel, and charcoal. Each rug is unique.', 1650.00, 'Textiles', 'https://images.unsplash.com/photo-1600166898405-da9535204843?w=800&q=80', 2, 'active'),
  ('00000000-0000-0000-0000-000000000003', 'Herrera & Ono', 'Copper Table Candleholder', 'Spun copper candleholder, 14cm tall. Holds a standard taper candle. The copper oxidises naturally over time, developing a living finish.', 98.00, 'Objets', 'https://images.unsplash.com/photo-1603204077779-bed963ea7d0e?w=800&q=80', 16, 'active'),
  ('00000000-0000-0000-0000-000000000004', 'Atelier Ferriere', 'Cast Iron Paperweight, River Stone', 'Cast iron paperweight in the form of a river stone. Each one poured and hand-finished in a small foundry in Provence. Substantial and quiet on a desk.', 195.00, 'Objets', 'https://images.unsplash.com/photo-1481277542470-605612bd2d61?w=800&q=80', 15, 'active'),
  ('00000000-0000-0000-0000-000000000004', 'Atelier Ferriere', 'Walnut Serving Board, Long', 'End-grain walnut serving board, 60cm x 20cm. Oiled with pure beeswax. A working object that improves with age. Hand-cut finger groove on one edge.', 215.00, 'Furniture', 'https://images.unsplash.com/photo-1606761568499-6d2451b23c66?w=800&q=80', 7, 'active'),
  ('00000000-0000-0000-0000-000000000004', 'Atelier Ferriere', 'Silver Signet Ring, Hammered', 'Sterling silver signet ring with a flat hammered face. Available in sizes 5-12. Made to order in Provence, 3-week lead time. Can be engraved on request.', 285.00, 'Jewelry', 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=800&q=80', 8, 'active'),
  ('00000000-0000-0000-0000-000000000004', 'Atelier Ferriere', 'Poured Concrete Bookend Pair', 'Cast from a custom mould in raw concrete with an exposed aggregate finish. Each pair weighs 1.8kg. 12cm x 8cm x 6cm. Felt-lined base to protect surfaces.', 125.00, 'Objets', 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=800&q=80', 10, 'active'),
  ('00000000-0000-0000-0000-000000000004', 'Atelier Ferriere', 'Raw Edge Mirror, Oval', 'Hand-cast resin frame with a raw, irregular edge. 60cm x 80cm. The frame catches light differently throughout the day. Wall fixings included.', 540.00, 'Furniture', 'https://images.unsplash.com/photo-1618220179428-22790b461013?w=800&q=80', 5, 'active')
on conflict do nothing;
