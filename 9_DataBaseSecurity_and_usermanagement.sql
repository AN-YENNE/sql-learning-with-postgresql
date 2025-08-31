
-- Data base security and user management: creating users and assigning roles
/*✅ Overview: What is User and Role Management?

In PostgreSQL:
A role can be a user (with login) or a group (no login).
PostgreSQL uses roles to control authentication, authorization, and access control.
Permissions like SELECT, INSERT, UPDATE, DELETE, CREATE, etc., can be granted or revoked on tables, databases, and schemas.

Syntax:
-- Create a role (group or user) with or without login
CREATE ROLE role_name [WITH] [LOGIN] [PASSWORD 'pass'] [options];

-- OR create a user (alias for CREATE ROLE ... LOGIN)
CREATE USER user_name [WITH] PASSWORD 'password';


*/
-- 🛠️ 1. Creating Roles and Users
CREATE ROLE mike WITH LOGIN;
-- mike is now a user who can connect to the database (no password set)

CREATE ROLE tom WITH LOGIN PASSWORD 'tom@123';
-- tom can login using this password

CREATE ROLE john WITH LOGIN PASSWORD 'John@123' SUPERUSER;
-- john is a superuser (full access to everything)

CREATE ROLE john1 WITH LOGIN PASSWORD 'John@123' CREATEDB;
-- john1 can create new databases

CREATE ROLE john2 WITH LOGIN PASSWORD 'John@123' CREATEROLE;
-- john2 can create and manage other roles

CREATE ROLE john3 WITH LOGIN PASSWORD 'John@123' VALID UNTIL '2024-05-31';
-- john3’s password expires after the given date

CREATE ROLE john4 WITH LOGIN PASSWORD 'John@123' CONNECTION LIMIT 10;
-- john4 can have a maximum of 10 simultaneous connections

CREATE ROLE john5 WITH LOGIN PASSWORD 'John@123' IN ROLE john4;
-- john5 inherits permissions from john4

CREATE USER john6 WITH PASSWORD 'John@123';
-- Equivalent to CREATE ROLE john6 WITH LOGIN PASSWORD 'John@123';


--🛡️ 2. Granting and Revoking Permissions
-- ✅ Syntax
-- Grant permissions
GRANT privilege [, ...] ON object TO role;

-- Revoke permissions
REVOKE privilege [, ...] ON object FROM role;

--Examples:
GRANT SELECT ON customer TO john1;
-- john1 can view (read) data from 'customer' table

GRANT INSERT, DELETE ON customer TO john1;
-- john1 can add and remove rows from 'customer'

GRANT SELECT ON ALL TABLES IN SCHEMA public TO john1;
-- Grant SELECT permission on all tables under 'public' schema

GRANT SELECT ON customer TO john1 WITH GRANT OPTION;
-- john1 can read from 'customer' and also grant this permission to others

REVOKE SELECT ON customer FROM john1;
-- Remove read access

REVOKE SELECT, INSERT ON customer FROM john1;
-- Remove both read and insert permissions

REVOKE ALL ON customer FROM john1;
-- Remove all permissions (read, write, delete, etc.)


--👥 3. Using Roles for Group-Based Access Control
--Syntax:
-- Create a group role (no login required)
CREATE ROLE group_name;

-- Assign privileges to group role
GRANT privilege ON object TO group_name;

-- Add users to group
GRANT group_name TO user_name;

CREATE ROLE sales_team;
-- Group role for sales team members

CREATE ROLE admins;
-- Group role for admins

GRANT SELECT ON ALL TABLES IN SCHEMA public TO sales_team;
-- All sales_team members can read from all tables

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admins;
-- Admins have full control over all tables

CREATE ROLE sales_managers IN ROLE sales_team;
-- sales_managers is a sub-role that inherits all permissions from sales_team

--🔐 Role Inheritance
-- When a role is created IN ROLE another_role, it inherits permissions.
-- If a user is in multiple roles, they get combined permissions.

/*📝 Notes and Tips
| 🔍 Concept                 | 💡 Tip                                                                |
| -------------------------- | --------------------------------------------------------------------- |
| **Roles vs Users**         | In PostgreSQL, `CREATE USER` is the same as `CREATE ROLE WITH LOGIN`  |
| **Least Privilege**        | Only give users the minimum permissions they need                     |
| **Groups (Roles)**         | Use roles to manage permissions for multiple users at once            |
| **WITH GRANT OPTION**      | Allows a user to pass on their permissions to others                  |
| **SUPERUSER**              | Be careful — superusers bypass all permission checks                  |
| **Password Expiry**        | Use `VALID UNTIL` to set expiration on passwords                      |
| **CONNECTION LIMIT**       | Helps control resource usage                                          |
| **Schema-level Grants**    | Use `ALL TABLES IN SCHEMA` to grant rights on every table in a schema |
| **Security Best Practice** | Avoid using superuser for day-to-day operations                       |
*/

-- Safely drop a role or user
DROP ROLE IF EXISTS john5;
--⚠️ You can’t drop a role if it's still in use (e.g., if it owns database objects or has dependencies).

-- View all roles
\du      -- (in psql shell)

-- Or use SQL:
SELECT rolname, rolsuper, rolcreaterole, rolcreatedb FROM pg_roles;

-- Check privileges on a specific table
SELECT grantee, privilege_type 
FROM information_schema.role_table_grants 
WHERE table_name = 'customer';

/*🎯 Summary

PostgreSQL uses roles for both users and groups.

You can assign different privileges to roles.

Use GRANT and REVOKE to control access.

Use group roles to manage multiple users more easily.

Always follow principle of least privilege.
	*/