SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;

CREATE TABLE usergroup (
    uid integer NOT NULL,
    gid integer NOT NULL
);
ALTER TABLE public.usergroup OWNER TO "notomorrow-de";
ALTER TABLE ONLY usergroup
    ADD CONSTRAINT usergroup_pkey PRIMARY KEY (uid, gid);
ALTER TABLE ONLY usergroup
    ADD CONSTRAINT usergroup_gid_fkey FOREIGN KEY (gid) REFERENCES groups(gid);
ALTER TABLE ONLY usergroup
    ADD CONSTRAINT usergroup_uid_fkey FOREIGN KEY (uid) REFERENCES users(uid);
