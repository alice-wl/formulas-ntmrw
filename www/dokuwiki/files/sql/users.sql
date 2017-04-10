SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;

CREATE TABLE users (
    uid integer NOT NULL,
    login character varying(20) NOT NULL,
    pass character varying(255) NOT NULL,
    fullname character varying(255) DEFAULT ''::character varying NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    domain character varying(255)
);
ALTER TABLE public.users OWNER TO "notomorrow-de";
CREATE SEQUENCE users_uid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.users_uid_seq OWNER TO "notomorrow-de";
ALTER SEQUENCE users_uid_seq OWNED BY users.uid;
ALTER TABLE ONLY users ALTER COLUMN uid SET DEFAULT nextval('users_uid_seq'::regclass);
ALTER TABLE ONLY users
    ADD CONSTRAINT users_login_domain_key UNIQUE (login, domain);
ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uid);
