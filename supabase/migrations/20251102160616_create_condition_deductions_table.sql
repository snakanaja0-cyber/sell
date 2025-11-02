/*
  # Create Condition Deductions Table

  1. New Tables
    - `condition_deductions`
      - `id` (uuid, primary key)
      - `condition_type` (text) - The condition level (good, average, below-average)
      - `deduction_percentage` (decimal) - The percentage deduction to apply (1% for all)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on `condition_deductions` table
    - Add policy for public read access (pricing is public information)
    
  3. Data
    - Insert initial values: good (1%), average (1%), below-average (1%)
*/

CREATE TABLE IF NOT EXISTS public.condition_deductions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  condition_type TEXT NOT NULL UNIQUE,
  deduction_percentage DECIMAL(5, 2) NOT NULL DEFAULT 1.00,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  CONSTRAINT valid_condition_type CHECK (condition_type IN ('good', 'average', 'below-average')),
  CONSTRAINT valid_deduction_percentage CHECK (deduction_percentage >= 0 AND deduction_percentage <= 100)
);

ALTER TABLE public.condition_deductions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can view condition deductions"
  ON public.condition_deductions
  FOR SELECT
  USING (true);

INSERT INTO public.condition_deductions (condition_type, deduction_percentage)
VALUES
  ('good', 1.00),
  ('average', 1.00),
  ('below-average', 1.00)
ON CONFLICT (condition_type) DO UPDATE
SET deduction_percentage = EXCLUDED.deduction_percentage;