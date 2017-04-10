SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET search_path = contacts, pg_catalog;

COPY users (uid, login, pass, fullname, email, domain) FROM stdin;
1	{{ adminuser }}	{{ adminpass }}	{{ adminuser }}	{{ adminemail }}	\N
SELECT pg_catalog.setval('users_uid_seq', 100, true);


COPY groups (gid, name) FROM stdin;
1	admin
2	users
3	manager
\.

SELECT pg_catalog.setval('groups_gid_seq', 100, true);

COPY usergroup (uid, gid) FROM stdin;
1	1
1	2
\.



