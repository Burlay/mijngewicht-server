--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.3
-- Dumped by pg_dump version 9.3.1
-- Started on 2014-04-08 07:10:25 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 178 (class 3079 OID 12617)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2850 (class 0 OID 0)
-- Dependencies: 178
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 170 (class 1259 OID 32768)
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE accounts (
    account_guid character(36) NOT NULL,
    username character varying(255) NOT NULL,
    password character(60) NOT NULL,
    account_id bigint NOT NULL
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- TOC entry 171 (class 1259 OID 32779)
-- Name: accounts_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE accounts_account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_account_id_seq OWNER TO postgres;

--
-- TOC entry 2851 (class 0 OID 0)
-- Dependencies: 171
-- Name: accounts_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE accounts_account_id_seq OWNED BY accounts.account_id;


--
-- TOC entry 175 (class 1259 OID 32803)
-- Name: measurements; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE measurements (
    measurement_id bigint NOT NULL,
    measurement_guid character(36) NOT NULL,
    weight double precision NOT NULL,
    date_taken timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    account_id bigint NOT NULL
);


ALTER TABLE public.measurements OWNER TO postgres;

--
-- TOC entry 174 (class 1259 OID 32801)
-- Name: measurements_measurement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE measurements_measurement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.measurements_measurement_id_seq OWNER TO postgres;

--
-- TOC entry 2852 (class 0 OID 0)
-- Dependencies: 174
-- Name: measurements_measurement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE measurements_measurement_id_seq OWNED BY measurements.measurement_id;


--
-- TOC entry 177 (class 1259 OID 49154)
-- Name: registered_devices; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE registered_devices (
    gcm_registration_id character varying(255) NOT NULL,
    registered_devices_id bigint NOT NULL,
    account_id bigint NOT NULL
);


ALTER TABLE public.registered_devices OWNER TO postgres;

--
-- TOC entry 176 (class 1259 OID 49152)
-- Name: registered_devices_registered_devices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE registered_devices_registered_devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.registered_devices_registered_devices_id_seq OWNER TO postgres;

--
-- TOC entry 2853 (class 0 OID 0)
-- Dependencies: 176
-- Name: registered_devices_registered_devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE registered_devices_registered_devices_id_seq OWNED BY registered_devices.registered_devices_id;


--
-- TOC entry 173 (class 1259 OID 32793)
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sessions (
    session_id bigint NOT NULL,
    session_guid character(36) NOT NULL,
    account_id bigint NOT NULL
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- TOC entry 172 (class 1259 OID 32791)
-- Name: sessions_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sessions_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sessions_session_id_seq OWNER TO postgres;

--
-- TOC entry 2854 (class 0 OID 0)
-- Dependencies: 172
-- Name: sessions_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sessions_session_id_seq OWNED BY sessions.session_id;


--
-- TOC entry 2708 (class 2604 OID 32781)
-- Name: account_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY accounts ALTER COLUMN account_id SET DEFAULT nextval('accounts_account_id_seq'::regclass);


--
-- TOC entry 2710 (class 2604 OID 32806)
-- Name: measurement_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY measurements ALTER COLUMN measurement_id SET DEFAULT nextval('measurements_measurement_id_seq'::regclass);


--
-- TOC entry 2712 (class 2604 OID 49157)
-- Name: registered_devices_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY registered_devices ALTER COLUMN registered_devices_id SET DEFAULT nextval('registered_devices_registered_devices_id_seq'::regclass);


--
-- TOC entry 2709 (class 2604 OID 32796)
-- Name: session_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sessions ALTER COLUMN session_id SET DEFAULT nextval('sessions_session_id_seq'::regclass);


--
-- TOC entry 2716 (class 2606 OID 32790)
-- Name: pk_accounts_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT pk_accounts_id PRIMARY KEY (account_id);


--
-- TOC entry 2728 (class 2606 OID 32808)
-- Name: pk_measurements_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY measurements
    ADD CONSTRAINT pk_measurements_id PRIMARY KEY (measurement_id);


--
-- TOC entry 2732 (class 2606 OID 49159)
-- Name: pk_registered_devices; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY registered_devices
    ADD CONSTRAINT pk_registered_devices PRIMARY KEY (gcm_registration_id);


--
-- TOC entry 2723 (class 2606 OID 32798)
-- Name: pk_sessions_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT pk_sessions_id PRIMARY KEY (session_id);


--
-- TOC entry 2718 (class 2606 OID 32774)
-- Name: u_account_guid; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT u_account_guid UNIQUE (account_guid);


--
-- TOC entry 2720 (class 2606 OID 32776)
-- Name: u_account_username; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT u_account_username UNIQUE (username);


--
-- TOC entry 2730 (class 2606 OID 32810)
-- Name: u_measurements_guid; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY measurements
    ADD CONSTRAINT u_measurements_guid UNIQUE (measurement_guid);


--
-- TOC entry 2725 (class 2606 OID 32800)
-- Name: u_sessions_guid; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT u_sessions_guid UNIQUE (session_guid);


--
-- TOC entry 2726 (class 1259 OID 40980)
-- Name: fki_measurements_account_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_measurements_account_id ON measurements USING btree (account_id);


--
-- TOC entry 2721 (class 1259 OID 40974)
-- Name: fki_sessions_account_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_sessions_account_id ON sessions USING btree (account_id);


--
-- TOC entry 2713 (class 1259 OID 32777)
-- Name: i_accounts_guid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX i_accounts_guid ON accounts USING btree (account_guid);


--
-- TOC entry 2714 (class 1259 OID 32778)
-- Name: i_accounts_username; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX i_accounts_username ON accounts USING btree (username);


--
-- TOC entry 2734 (class 2606 OID 40975)
-- Name: fk_measurements_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY measurements
    ADD CONSTRAINT fk_measurements_account_id FOREIGN KEY (account_id) REFERENCES accounts(account_id);


--
-- TOC entry 2735 (class 2606 OID 49160)
-- Name: fk_registered_devices_accounts; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY registered_devices
    ADD CONSTRAINT fk_registered_devices_accounts FOREIGN KEY (account_id) REFERENCES accounts(account_id);


--
-- TOC entry 2733 (class 2606 OID 40969)
-- Name: fk_sessions_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT fk_sessions_account_id FOREIGN KEY (account_id) REFERENCES accounts(account_id);


--
-- TOC entry 2849 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2014-04-08 07:10:25 CEST

--
-- PostgreSQL database dump complete
--

