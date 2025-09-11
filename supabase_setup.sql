-- Supabase Database Setup for Leave Request System
-- Run this script in your Supabase SQL editor

-- Create leave_requests table
CREATE TABLE IF NOT EXISTS leave_requests (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    userId TEXT NOT NULL,
    reason TEXT NOT NULL,
    startDate TIMESTAMP WITH TIME ZONE NOT NULL,
    endDate TIMESTAMP WITH TIME ZONE NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'viewed', 'rejected')),
    createdAt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    imageUrls JSONB DEFAULT '[]'::jsonb,
    adminNotes TEXT,
    statusUpdatedAt TIMESTAMP WITH TIME ZONE,
    statusUpdatedBy TEXT
);

-- Create notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    userId TEXT NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'general' CHECK (type IN ('leaveRequestUpdate', 'general')),
    isRead BOOLEAN DEFAULT FALSE,
    createdAt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    leaveRequestId TEXT,
    data JSONB
);

-- Create users table (if not exists)
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    firstName TEXT NOT NULL,
    lastName TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    age TEXT,
    dob TEXT,
    dateOfJoining TEXT,
    designation TEXT NOT NULL DEFAULT 'employee' CHECK (designation IN ('admin', 'teamLeader', 'manager', 'employee')),
    imageUrl TEXT,
    address TEXT,
    phone TEXT,
    salary NUMERIC,
    createdAt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    employeeId TEXT,
    department TEXT,
    employeeType TEXT,
    branchCode TEXT,
    officeStartTime TEXT,
    officeEndTime TEXT
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_leave_requests_user_id ON leave_requests(userId);
CREATE INDEX IF NOT EXISTS idx_leave_requests_status ON leave_requests(status);
CREATE INDEX IF NOT EXISTS idx_leave_requests_created_at ON leave_requests(createdAt DESC);
CREATE INDEX IF NOT EXISTS idx_leave_requests_user_status ON leave_requests(userId, status);

CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(userId);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(isRead);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(createdAt DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_user_read ON notifications(userId, isRead);

CREATE INDEX IF NOT EXISTS idx_users_designation ON users(designation);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Enable Row Level Security (RLS)
ALTER TABLE leave_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for leave_requests
CREATE POLICY "Users can view their own leave requests" ON leave_requests
    FOR SELECT USING (auth.uid()::text = userId);

CREATE POLICY "Admins can view all leave requests" ON leave_requests
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = auth.uid()::text 
            AND users.designation = 'admin'
        )
    );

CREATE POLICY "Users can create their own leave requests" ON leave_requests
    FOR INSERT WITH CHECK (auth.uid()::text = userId);

CREATE POLICY "Admins can update leave requests" ON leave_requests
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = auth.uid()::text 
            AND users.designation = 'admin'
        )
    );

CREATE POLICY "Admins can delete leave requests" ON leave_requests
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = auth.uid()::text 
            AND users.designation = 'admin'
        )
    );

-- Create RLS policies for notifications
CREATE POLICY "Users can view their own notifications" ON notifications
    FOR SELECT USING (auth.uid()::text = userId);

CREATE POLICY "Users can update their own notifications" ON notifications
    FOR UPDATE USING (auth.uid()::text = userId);

CREATE POLICY "System can create notifications" ON notifications
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can delete their own notifications" ON notifications
    FOR DELETE USING (auth.uid()::text = userId);

-- Create RLS policies for users
CREATE POLICY "Users can view their own profile" ON users
    FOR SELECT USING (auth.uid()::text = id);

CREATE POLICY "Admins can manage all users" ON users
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = auth.uid()::text 
            AND users.designation = 'admin'
        )
    );

-- Create storage bucket for leave request images
INSERT INTO storage.buckets (id, name, public) 
VALUES ('zeepalm-document', 'zeepalm-document', true)
ON CONFLICT (id) DO NOTHING;

-- Create storage policies
CREATE POLICY "Authenticated users can upload images" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'zeepalm-document' 
        AND auth.role() = 'authenticated'
    );

CREATE POLICY "Anyone can view images" ON storage.objects
    FOR SELECT USING (bucket_id = 'zeepalm-document');

CREATE POLICY "Users can delete their own images" ON storage.objects
    FOR DELETE USING (
        bucket_id = 'zeepalm-document' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- Insert sample admin user (replace with your actual admin credentials)
INSERT INTO users (
    id, 
    firstName, 
    lastName, 
    email, 
    password, 
    designation
) VALUES (
    'admin-user-id', -- Replace with actual admin user ID
    'Admin',
    'User',
    'admin@example.com', -- Replace with actual admin email
    'admin123', -- Replace with actual admin password
    'admin'
) ON CONFLICT (id) DO NOTHING;

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- Create functions for real-time subscriptions
CREATE OR REPLACE FUNCTION notify_leave_request_change()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM pg_notify('leave_request_changed', row_to_json(NEW)::text);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION notify_notification_change()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM pg_notify('notification_changed', row_to_json(NEW)::text);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for real-time updates
DROP TRIGGER IF EXISTS leave_request_change_trigger ON leave_requests;
CREATE TRIGGER leave_request_change_trigger
    AFTER INSERT OR UPDATE OR DELETE ON leave_requests
    FOR EACH ROW EXECUTE FUNCTION notify_leave_request_change();

DROP TRIGGER IF EXISTS notification_change_trigger ON notifications;
CREATE TRIGGER notification_change_trigger
    AFTER INSERT OR UPDATE OR DELETE ON notifications
    FOR EACH ROW EXECUTE FUNCTION notify_notification_change();
