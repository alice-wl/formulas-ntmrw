SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;

CREATE TABLE groups (
    gid integer NOT NULL,
    name character varying(50) NOT NULL
);
ALTER TABLE public.groups OWNER TO "notomorrow-de";
CREATE SEQUENCE groups_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.groups_gid_seq OWNER TO "notomorrow-de";
ALTER SEQUENCE groups_gid_seq OWNED BY groups.gid;
ALTER TABLE ONLY groups ALTER COLUMN gid SET DEFAULT nextval('groups_gid_seq'::regclass);
ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_name_key UNIQUE (name);
ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (gid);
