


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";





SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."Gratitude Entries" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" DEFAULT "auth"."uid"(),
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "text" "text",
    "audio_path" "text",
    "mood" "text"
);


ALTER TABLE "public"."Gratitude Entries" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."Profiles" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "email" "text"
);


ALTER TABLE "public"."Profiles" OWNER TO "postgres";


ALTER TABLE ONLY "public"."Gratitude Entries"
    ADD CONSTRAINT "Gratitude Entries_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."Profiles"
    ADD CONSTRAINT "Profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."Gratitude Entries"
    ADD CONSTRAINT "fk_user" FOREIGN KEY ("user_id") REFERENCES "public"."Profiles"("id") ON DELETE CASCADE;



ALTER TABLE "public"."Gratitude Entries" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."Profiles" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "Users can insert their own entries" ON "public"."Gratitude Entries" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can insert their own profiles" ON "public"."Profiles" FOR INSERT WITH CHECK (("auth"."uid"() = "id"));



CREATE POLICY "Users can update their own profiles" ON "public"."Profiles" FOR UPDATE TO "authenticated" USING (("auth"."uid"() = "id")) WITH CHECK (("auth"."uid"() = "id"));



CREATE POLICY "Users can view their own entries" ON "public"."Gratitude Entries" FOR SELECT TO "authenticated" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can view their own profiles" ON "public"."Profiles" FOR SELECT TO "authenticated" USING (("auth"."uid"() = "id"));





ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";








































































































































































GRANT ALL ON TABLE "public"."Gratitude Entries" TO "anon";
GRANT ALL ON TABLE "public"."Gratitude Entries" TO "authenticated";
GRANT ALL ON TABLE "public"."Gratitude Entries" TO "service_role";



GRANT ALL ON TABLE "public"."Profiles" TO "anon";
GRANT ALL ON TABLE "public"."Profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."Profiles" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































drop extension if exists "pg_net";


  create policy "Give users authenticated access to folder 1r6807q_0"
  on "storage"."objects"
  as permissive
  for select
  to public
using (((bucket_id = 'gratitude-audio'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "anon read gratitude-audio 1r6807q_0"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'gratitude-audio'::text));



