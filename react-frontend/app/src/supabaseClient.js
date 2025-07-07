import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.REACT_APP_SUPABASE_URL || 'SUPABASE_URL_PLACEHOLDER';
const supabaseAnonKey = process.env.REACT_APP_SUPABASE_ANON_KEY || 'SUPABASE_ANON_KEY_PLACEHOLDER';

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
