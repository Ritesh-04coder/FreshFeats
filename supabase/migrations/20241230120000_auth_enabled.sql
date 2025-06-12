-- supabase/migrations/20241230120000_auth_enabled.sql

-- Create user profiles table
CREATE TABLE public.user_profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT NOT NULL,
  full_name TEXT,
  phone_number TEXT,
  avatar_url TEXT,
  address JSONB,
  preferences JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create restaurants table
CREATE TABLE public.restaurants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  cuisine_type TEXT NOT NULL,
  image_url TEXT,
  rating DECIMAL(2,1) DEFAULT 0.0,
  total_reviews INTEGER DEFAULT 0,
  delivery_fee DECIMAL(5,2) DEFAULT 0.0,
  min_order_amount DECIMAL(5,2) DEFAULT 0.0,
  estimated_delivery_time_min INTEGER DEFAULT 30,
  estimated_delivery_time_max INTEGER DEFAULT 45,
  is_active BOOLEAN DEFAULT true,
  address JSONB,
  location GEOGRAPHY(POINT),
  operating_hours JSONB,
  features JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create menu categories table
CREATE TABLE public.menu_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create menu items table
CREATE TABLE public.menu_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE,
  category_id UUID REFERENCES public.menu_categories(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(8,2) NOT NULL,
  image_url TEXT,
  is_available BOOLEAN DEFAULT true,
  is_vegetarian BOOLEAN DEFAULT false,
  is_vegan BOOLEAN DEFAULT false,
  is_gluten_free BOOLEAN DEFAULT false,
  allergens TEXT[],
  customization_options JSONB DEFAULT '[]',
  nutrition_info JSONB,
  preparation_time INTEGER DEFAULT 15,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create orders table
CREATE TABLE public.orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE,
  order_number TEXT UNIQUE NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  subtotal DECIMAL(8,2) NOT NULL,
  delivery_fee DECIMAL(5,2) DEFAULT 0.0,
  tax_amount DECIMAL(5,2) DEFAULT 0.0,
  discount_amount DECIMAL(5,2) DEFAULT 0.0,
  total_amount DECIMAL(8,2) NOT NULL,
  payment_method TEXT,
  payment_status TEXT DEFAULT 'pending',
  payment_intent_id TEXT,
  delivery_address JSONB NOT NULL,
  delivery_instructions TEXT,
  estimated_delivery_time TIMESTAMPTZ,
  actual_delivery_time TIMESTAMPTZ,
  promo_code TEXT,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create order items table
CREATE TABLE public.order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE,
  menu_item_id UUID REFERENCES public.menu_items(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL DEFAULT 1,
  unit_price DECIMAL(8,2) NOT NULL,
  total_price DECIMAL(8,2) NOT NULL,
  customizations JSONB DEFAULT '[]',
  special_instructions TEXT,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create drivers table
CREATE TABLE public.drivers (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  full_name TEXT NOT NULL,
  phone_number TEXT NOT NULL,
  vehicle_type TEXT,
  vehicle_number TEXT,
  license_number TEXT,
  rating DECIMAL(2,1) DEFAULT 5.0,
  total_deliveries INTEGER DEFAULT 0,
  is_available BOOLEAN DEFAULT false,
  current_location GEOGRAPHY(POINT),
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create order tracking table
CREATE TABLE public.order_tracking (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE,
  driver_id UUID REFERENCES public.drivers(id) ON DELETE SET NULL,
  status TEXT NOT NULL,
  location GEOGRAPHY(POINT),
  notes TEXT,
  timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create reviews table
CREATE TABLE public.reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE,
  order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  driver_rating INTEGER CHECK (driver_rating >= 1 AND driver_rating <= 5),
  driver_comment TEXT,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create user favorites table
CREATE TABLE public.user_favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, restaurant_id)
);

-- Create promo codes table
CREATE TABLE public.promo_codes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  description TEXT,
  discount_type TEXT NOT NULL, -- 'percentage' or 'fixed'
  discount_value DECIMAL(5,2) NOT NULL,
  min_order_amount DECIMAL(8,2) DEFAULT 0.0,
  max_discount_amount DECIMAL(8,2),
  usage_limit INTEGER,
  used_count INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  valid_from TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  valid_until TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_restaurants_location ON public.restaurants USING GIST (location);
CREATE INDEX idx_restaurants_cuisine ON public.restaurants(cuisine_type);
CREATE INDEX idx_restaurants_rating ON public.restaurants(rating DESC);
CREATE INDEX idx_menu_items_restaurant ON public.menu_items(restaurant_id);
CREATE INDEX idx_menu_items_category ON public.menu_items(category_id);
CREATE INDEX idx_orders_user ON public.orders(user_id);
CREATE INDEX idx_orders_restaurant ON public.orders(restaurant_id);
CREATE INDEX idx_orders_status ON public.orders(status);
CREATE INDEX idx_order_tracking_order ON public.order_tracking(order_id);
CREATE INDEX idx_order_tracking_timestamp ON public.order_tracking(timestamp DESC);
CREATE INDEX idx_drivers_location ON public.drivers USING GIST (current_location);
CREATE INDEX idx_drivers_available ON public.drivers(is_available);
CREATE INDEX idx_user_favorites_user ON public.user_favorites(user_id);

-- Enable Row Level Security
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.menu_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.drivers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_tracking ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.promo_codes ENABLE ROW LEVEL SECURITY;

-- Create helper functions
CREATE FUNCTION public.is_restaurant_owner(restaurant_id UUID)
RETURNS BOOLEAN
LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.restaurants 
    WHERE id = restaurant_id AND owner_id = auth.uid()
  )
$$;

CREATE FUNCTION public.is_driver()
RETURNS BOOLEAN
LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.drivers WHERE id = auth.uid()
  )
$$;

-- RLS Policies

-- User profiles: users can only see and edit their own profile
CREATE POLICY "users_crud_own_profile"
ON public.user_profiles
FOR ALL
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Restaurants: public read, owners can manage their own
CREATE POLICY "public_can_read_restaurants"
ON public.restaurants
FOR SELECT
TO public
USING (is_active = true);

CREATE POLICY "owners_can_manage_restaurants"
ON public.restaurants
FOR ALL
TO authenticated
USING (owner_id = auth.uid())
WITH CHECK (owner_id = auth.uid());

-- Menu categories: public read, restaurant owners can manage
CREATE POLICY "public_can_read_menu_categories"
ON public.menu_categories
FOR SELECT
TO public
USING (is_active = true);

CREATE POLICY "restaurant_owners_can_manage_categories"
ON public.menu_categories
FOR ALL
TO authenticated
USING (public.is_restaurant_owner(restaurant_id))
WITH CHECK (public.is_restaurant_owner(restaurant_id));

-- Menu items: public read, restaurant owners can manage
CREATE POLICY "public_can_read_menu_items"
ON public.menu_items
FOR SELECT
TO public
USING (is_available = true);

CREATE POLICY "restaurant_owners_can_manage_items"
ON public.menu_items
FOR ALL
TO authenticated
USING (public.is_restaurant_owner(restaurant_id))
WITH CHECK (public.is_restaurant_owner(restaurant_id));

-- Orders: users can see their own orders, restaurants can see orders for their restaurant
CREATE POLICY "users_can_read_own_orders"
ON public.orders
FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY "users_can_create_orders"
ON public.orders
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "restaurants_can_read_orders"
ON public.orders
FOR SELECT
TO authenticated
USING (public.is_restaurant_owner(restaurant_id));

CREATE POLICY "restaurants_can_update_orders"
ON public.orders
FOR UPDATE
TO authenticated
USING (public.is_restaurant_owner(restaurant_id))
WITH CHECK (public.is_restaurant_owner(restaurant_id));

-- Order items: linked to order permissions
CREATE POLICY "users_can_read_own_order_items"
ON public.order_items
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.orders 
    WHERE id = order_id AND user_id = auth.uid()
  )
);

CREATE POLICY "users_can_create_order_items"
ON public.order_items
FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.orders 
    WHERE id = order_id AND user_id = auth.uid()
  )
);

-- Drivers: drivers can manage their own profile
CREATE POLICY "drivers_crud_own_profile"
ON public.drivers
FOR ALL
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

CREATE POLICY "public_can_read_drivers"
ON public.drivers
FOR SELECT
TO authenticated
USING (true);

-- Order tracking: users can see tracking for their orders, drivers can update
CREATE POLICY "users_can_read_order_tracking"
ON public.order_tracking
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.orders 
    WHERE id = order_id AND user_id = auth.uid()
  )
);

CREATE POLICY "drivers_can_manage_tracking"
ON public.order_tracking
FOR ALL
TO authenticated
USING (public.is_driver())
WITH CHECK (public.is_driver());

-- Reviews: users can manage their own reviews, public can read
CREATE POLICY "public_can_read_reviews"
ON public.reviews
FOR SELECT
TO public
USING (true);

CREATE POLICY "users_can_manage_own_reviews"
ON public.reviews
FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- User favorites: users can manage their own favorites
CREATE POLICY "users_can_manage_favorites"
ON public.user_favorites
FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Promo codes: public can read active codes
CREATE POLICY "public_can_read_promo_codes"
ON public.promo_codes
FOR SELECT
TO public
USING (is_active = true AND valid_from <= NOW() AND (valid_until IS NULL OR valid_until >= NOW()));

-- Insert sample data
INSERT INTO public.restaurants (id, name, description, cuisine_type, image_url, rating, total_reviews, delivery_fee, min_order_amount, estimated_delivery_time_min, estimated_delivery_time_max, address, features) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'Pizza Palace', 'Authentic Italian pizzas with fresh ingredients', 'Italian', 'https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 4.5, 324, 2.99, 15.00, 25, 35, '{"street": "123 Main St", "city": "New York", "state": "NY", "zipcode": "10001"}', '["fast_delivery", "popular"]'),
('550e8400-e29b-41d4-a716-446655440002', 'Dragon Garden', 'Traditional Chinese cuisine with modern twists', 'Chinese', 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 4.2, 187, 3.49, 20.00, 30, 40, '{"street": "456 Oak Ave", "city": "New York", "state": "NY", "zipcode": "10002"}', '["vegetarian_options"]'),
('550e8400-e29b-41d4-a716-446655440003', 'Healthy Bites', 'Fresh and nutritious meals for healthy lifestyle', 'Healthy', 'https://images.pexels.com/photos/1640772/pexels-photo-1640772.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 4.7, 892, 1.99, 12.00, 20, 30, '{"street": "789 Pine Rd", "city": "New York", "state": "NY", "zipcode": "10003"}', '["healthy", "organic", "free_delivery"]'),
('550e8400-e29b-41d4-a716-446655440004', 'Burger Junction', 'Gourmet burgers made with premium ingredients', 'American', 'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 4.0, 156, 2.49, 10.00, 15, 25, '{"street": "321 Elm St", "city": "New York", "state": "NY", "zipcode": "10004"}', '["popular"]'),
('550e8400-e29b-41d4-a716-446655440005', 'Sushi Master', 'Finest sushi and Japanese delicacies', 'Japanese', 'https://images.pexels.com/photos/357756/pexels-photo-357756.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 4.8, 423, 4.99, 25.00, 35, 45, '{"street": "654 Maple Dr", "city": "New York", "state": "NY", "zipcode": "10005"}', '["premium", "fresh_fish"]'),
('550e8400-e29b-41d4-a716-446655440006', 'Taco Fiesta', 'Authentic Mexican street food and tacos', 'Mexican', 'https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 4.3, 234, 2.99, 15.00, 20, 30, '{"street": "987 Cedar Ln", "city": "New York", "state": "NY", "zipcode": "10006"}', '["spicy", "authentic"]');

-- Insert sample menu categories
INSERT INTO public.menu_categories (id, restaurant_id, name, description, display_order) VALUES
('650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Pizzas', 'Our signature wood-fired pizzas', 1),
('650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'Appetizers', 'Start your meal right', 2),
('650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', 'Main Dishes', 'Traditional Chinese entrees', 1),
('650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440003', 'Salads', 'Fresh and healthy options', 1),
('650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440004', 'Burgers', 'Gourmet burger selection', 1);

-- Insert sample menu items
INSERT INTO public.menu_items (id, restaurant_id, category_id, name, description, price, image_url, is_vegetarian, customization_options) VALUES
('750e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', 'Margherita Pizza', 'Fresh tomatoes, mozzarella, basil', 18.99, 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop', true, '[{"name": "Size", "options": ["Small", "Medium", "Large"], "required": true}, {"name": "Crust", "options": ["Thin", "Thick"], "required": false}]'),
('750e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440002', 'Garlic Bread', 'Crispy bread with garlic butter', 8.99, 'https://images.unsplash.com/photo-1549458223-e2f7c2c72d66?w=400&h=300&fit=crop', true, '[]'),
('750e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440003', 'Sweet and Sour Chicken', 'Tender chicken in sweet and sour sauce', 16.99, 'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=400&h=300&fit=crop', false, '[{"name": "Spice Level", "options": ["Mild", "Medium", "Hot"], "required": true}]'),
('750e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440004', 'Caesar Salad', 'Crisp romaine, parmesan, croutons', 12.99, 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400&h=300&fit=crop', true, '[{"name": "Protein", "options": ["None", "Grilled Chicken", "Tofu"], "required": false}]'),
('750e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440005', 'Classic Cheeseburger', 'Beef patty with cheese, lettuce, tomato', 14.99, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop', false, '[{"name": "Doneness", "options": ["Medium Rare", "Medium", "Well Done"], "required": true}]');

-- Insert sample promo codes
INSERT INTO public.promo_codes (code, description, discount_type, discount_value, min_order_amount, is_active, valid_until) VALUES
('SAVE10', '10% off your order', 'percentage', 10.00, 20.00, true, NOW() + INTERVAL '30 days'),
('FREEDELIV', 'Free delivery on orders over $25', 'fixed', 5.00, 25.00, true, NOW() + INTERVAL '30 days'),
('WELCOME20', '20% off for new customers', 'percentage', 20.00, 15.00, true, NOW() + INTERVAL '30 days');