PGDMP     !                     {            forum    14.3    14.3 P    M           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            N           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            O           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            P           1262    16394    forum    DATABASE     a   CREATE DATABASE forum WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Czech_Czechia.1250';
    DROP DATABASE forum;
                postgres    false            �            1255    32869    count_comm(integer)    FUNCTION       CREATE FUNCTION public.count_comm(komentar integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE celkem integer;

BEGIN

	SELECT COUNT(k.id) INTO celkem
	FROM komentare k
	JOIN prispevky p
	ON p.id = k.prispevek_id
	WHERE k.prispevek_id = komentar;
	
	RETURN celkem;
	
END;
$$;
 3   DROP FUNCTION public.count_comm(komentar integer);
       public          postgres    false            �            1255    32842    count_rows_of_table(text, text)    FUNCTION     �  CREATE FUNCTION public.count_rows_of_table(schema text, tablename text) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE
  query_template CONSTANT TEXT NOT NULL :='SELECT COUNT(*) FROM "?schema"."?tablename"';

  query CONSTANT TEXT NOT NULL :=
    REPLACE(
      REPLACE(
        query_template, '?schema', schema),
     '?tablename', tablename);

  result INT NOT NULL := -1;
BEGIN
  EXECUTE query INTO result;
  RETURN result;
END;$$;
 G   DROP FUNCTION public.count_rows_of_table(schema text, tablename text);
       public          postgres    false            �            1255    32871    random_hodnoceni()    FUNCTION     ~  CREATE FUNCTION public.random_hodnoceni() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE 
	cur CURSOR FOR SELECT id, hodnoceni, uzivatel_id, prispevek_id FROM hodnoceni;
	cur_row RECORD;
BEGIN
	open cur;
LOOP
	fetch cur into cur_row;
	EXIT WHEN NOT FOUND;
	UPDATE hodnoceni SET hodnoceni = trunc(random() * 5 + 1) WHERE cur_row.id = hodnoceni.id;
END LOOP;
	close cur;
END;
$$;
 )   DROP FUNCTION public.random_hodnoceni();
       public          postgres    false            �            1255    32885    random_random_hodnoceni() 	   PROCEDURE       CREATE PROCEDURE public.random_random_hodnoceni()
    LANGUAGE plpgsql
    AS $$DECLARE 
	cur CURSOR FOR SELECT id, hodnoceni, uzivatel_id, prispevek_id FROM hodnoceni;
	cur_row RECORD;
BEGIN
	open cur;
LOOP
	fetch cur into cur_row;
	EXIT WHEN NOT FOUND;
	UPDATE hodnoceni SET hodnoceni = trunc(random() * 5 + 1) WHERE cur_row.id = hodnoceni.id;
END LOOP;
	close cur;
IF trunc(random() * 2 + 1) = 1 THEN
    COMMIT;
	RAISE NOTICE 'Commitnuto! (Success)';
ELSE
	ROLLBACK;
	raise NOTICE 'Rollbacknuto! (Fail)';
END IF;
END;
$$;
 1   DROP PROCEDURE public.random_random_hodnoceni();
       public          postgres    false            �            1255    32882    uzivatele_changes()    FUNCTION     `  CREATE FUNCTION public.uzivatele_changes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NEW.prezdivka <> OLD.prezdivka OR NEW.heslo <> OLD.heslo OR NEW.email <> OLD.email THEN
		 INSERT INTO uzivatele_audits(uzivatel_id,prezdivka,heslo,email,zmena)
		 VALUES(OLD.id,OLD.prezdivka,OLD.heslo,OLD.email,now());
	END IF;

	RETURN NEW;
END;
$$;
 *   DROP FUNCTION public.uzivatele_changes();
       public          postgres    false            �            1259    16400    hodnoceni_id_seq    SEQUENCE     �   CREATE SEQUENCE public.hodnoceni_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.hodnoceni_id_seq;
       public          postgres    false            �            1259    16395 	   hodnoceni    TABLE     �   CREATE TABLE public.hodnoceni (
    id integer DEFAULT nextval('public.hodnoceni_id_seq'::regclass) NOT NULL,
    hodnoceni numeric NOT NULL,
    uzivatel_id integer NOT NULL,
    prispevek_id integer NOT NULL
);
    DROP TABLE public.hodnoceni;
       public         heap    postgres    false    210            Q           0    0    TABLE hodnoceni    ACL     9   GRANT SELECT,DELETE ON TABLE public.hodnoceni TO matejr;
          public          postgres    false    209            �            1259    16406    komentare_id_seq    SEQUENCE     �   CREATE SEQUENCE public.komentare_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.komentare_id_seq;
       public          postgres    false            �            1259    16401 	   komentare    TABLE     �   CREATE TABLE public.komentare (
    id integer DEFAULT nextval('public.komentare_id_seq'::regclass) NOT NULL,
    uzivatel_id integer NOT NULL,
    prispevek_id integer NOT NULL,
    text text NOT NULL
);
    DROP TABLE public.komentare;
       public         heap    postgres    false    212            R           0    0    TABLE komentare    ACL     9   GRANT SELECT,DELETE ON TABLE public.komentare TO matejr;
          public          postgres    false    211            �            1259    16419    role    TABLE     \   CREATE TABLE public.role (
    id integer NOT NULL,
    nazev character varying NOT NULL
);
    DROP TABLE public.role;
       public         heap    postgres    false            S           0    0 
   TABLE role    ACL     4   GRANT SELECT,DELETE ON TABLE public.role TO matejr;
          public          postgres    false    217            �            1259    16431    uzivatele_role    TABLE     g   CREATE TABLE public.uzivatele_role (
    role_id integer NOT NULL,
    uzivatel_id integer NOT NULL
);
 "   DROP TABLE public.uzivatele_role;
       public         heap    postgres    false            T           0    0    TABLE uzivatele_role    ACL     >   GRANT SELECT,DELETE ON TABLE public.uzivatele_role TO matejr;
          public          postgres    false    221            �            1259    24695    number_of_sers    VIEW     �   CREATE VIEW public.number_of_sers AS
 SELECT r.nazev
   FROM (public.role r
     RIGHT JOIN public.uzivatele_role ur ON ((r.id = ur.role_id)));
 !   DROP VIEW public.number_of_sers;
       public          postgres    false    217    221    217            U           0    0    TABLE number_of_sers    ACL     >   GRANT SELECT,DELETE ON TABLE public.number_of_sers TO matejr;
          public          postgres    false    222            �            1259    16413 	   prispevky    TABLE     �   CREATE TABLE public.prispevky (
    id integer NOT NULL,
    nazev character varying NOT NULL,
    obsah text NOT NULL,
    obrazek character varying NOT NULL,
    uzivatel_id integer NOT NULL
);
    DROP TABLE public.prispevky;
       public         heap    postgres    false            V           0    0    TABLE prispevky    ACL     9   GRANT SELECT,DELETE ON TABLE public.prispevky TO matejr;
          public          postgres    false    215            �            1259    16425 	   uzivatele    TABLE     �   CREATE TABLE public.uzivatele (
    id integer NOT NULL,
    prezdivka character varying NOT NULL,
    heslo character varying NOT NULL,
    email character varying NOT NULL
);
    DROP TABLE public.uzivatele;
       public         heap    postgres    false            W           0    0    TABLE uzivatele    ACL     9   GRANT SELECT,DELETE ON TABLE public.uzivatele TO matejr;
          public          postgres    false    219            �            1259    32849    number_of_users    VIEW     �  CREATE VIEW public.number_of_users AS
 SELECT r.nazev,
    count(r.nazev) AS pocet_uzivatelu,
    count(p.id) AS pocet_prispevku
   FROM (((public.role r
     RIGHT JOIN public.uzivatele_role ur ON ((r.id = ur.role_id)))
     JOIN public.uzivatele u ON ((u.id = ur.uzivatel_id)))
     LEFT JOIN public.prispevky p ON ((p.uzivatel_id = u.id)))
  GROUP BY r.nazev
  ORDER BY (count(r.nazev));
 "   DROP VIEW public.number_of_users;
       public          postgres    false    215    215    217    217    219    221    221            X           0    0    TABLE number_of_users    ACL     8   GRANT SELECT ON TABLE public.number_of_users TO matejr;
          public          postgres    false    223            �            1259    16412    odpovedi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.odpovedi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.odpovedi_id_seq;
       public          postgres    false            �            1259    16407    odpovedi    TABLE     �   CREATE TABLE public.odpovedi (
    id integer DEFAULT nextval('public.odpovedi_id_seq'::regclass) NOT NULL,
    text text NOT NULL,
    uzivatel_id integer NOT NULL,
    komentar_id integer NOT NULL
);
    DROP TABLE public.odpovedi;
       public         heap    postgres    false    214            Y           0    0    TABLE odpovedi    ACL     8   GRANT SELECT,DELETE ON TABLE public.odpovedi TO matejr;
          public          postgres    false    213            �            1259    16418    posts_id_seq    SEQUENCE     �   CREATE SEQUENCE public.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.posts_id_seq;
       public          postgres    false    215            Z           0    0    posts_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.posts_id_seq OWNED BY public.prispevky.id;
          public          postgres    false    216            �            1259    16424    roles_id_seq    SEQUENCE     �   CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.roles_id_seq;
       public          postgres    false    217            [           0    0    roles_id_seq    SEQUENCE OWNED BY     <   ALTER SEQUENCE public.roles_id_seq OWNED BY public.role.id;
          public          postgres    false    218            �            1259    16430    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    219            \           0    0    users_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.users_id_seq OWNED BY public.uzivatele.id;
          public          postgres    false    220            �            1259    32877    uzivatele_audits    TABLE       CREATE TABLE public.uzivatele_audits (
    id integer NOT NULL,
    uzivatel_id integer NOT NULL,
    prezdivka character varying NOT NULL,
    heslo character varying NOT NULL,
    email character varying NOT NULL,
    zmena timestamp(6) without time zone NOT NULL
);
 $   DROP TABLE public.uzivatele_audits;
       public         heap    postgres    false            ]           0    0    TABLE uzivatele_audits    ACL     9   GRANT SELECT ON TABLE public.uzivatele_audits TO matejr;
          public          postgres    false    225            �            1259    32876    uzivatele_audits_id_seq    SEQUENCE     �   ALTER TABLE public.uzivatele_audits ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.uzivatele_audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    225            �           2604    32893    prispevky id    DEFAULT     h   ALTER TABLE ONLY public.prispevky ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);
 ;   ALTER TABLE public.prispevky ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215            �           2604    32894    role id    DEFAULT     c   ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 6   ALTER TABLE public.role ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217            �           2604    32895    uzivatele id    DEFAULT     h   ALTER TABLE ONLY public.uzivatele ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 ;   ALTER TABLE public.uzivatele ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219            <          0    16395 	   hodnoceni 
   TABLE DATA           M   COPY public.hodnoceni (id, hodnoceni, uzivatel_id, prispevek_id) FROM stdin;
    public          postgres    false    209   N]       >          0    16401 	   komentare 
   TABLE DATA           H   COPY public.komentare (id, uzivatel_id, prispevek_id, text) FROM stdin;
    public          postgres    false    211   �_       @          0    16407    odpovedi 
   TABLE DATA           F   COPY public.odpovedi (id, text, uzivatel_id, komentar_id) FROM stdin;
    public          postgres    false    213   f       B          0    16413 	   prispevky 
   TABLE DATA           K   COPY public.prispevky (id, nazev, obsah, obrazek, uzivatel_id) FROM stdin;
    public          postgres    false    215   �i       D          0    16419    role 
   TABLE DATA           )   COPY public.role (id, nazev) FROM stdin;
    public          postgres    false    217   z�       F          0    16425 	   uzivatele 
   TABLE DATA           @   COPY public.uzivatele (id, prezdivka, heslo, email) FROM stdin;
    public          postgres    false    219   ��       J          0    32877    uzivatele_audits 
   TABLE DATA           [   COPY public.uzivatele_audits (id, uzivatel_id, prezdivka, heslo, email, zmena) FROM stdin;
    public          postgres    false    225   %�       H          0    16431    uzivatele_role 
   TABLE DATA           >   COPY public.uzivatele_role (role_id, uzivatel_id) FROM stdin;
    public          postgres    false    221   �       ^           0    0    hodnoceni_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.hodnoceni_id_seq', 170, true);
          public          postgres    false    210            _           0    0    komentare_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.komentare_id_seq', 48, true);
          public          postgres    false    212            `           0    0    odpovedi_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.odpovedi_id_seq', 55, true);
          public          postgres    false    214            a           0    0    posts_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.posts_id_seq', 28, true);
          public          postgres    false    216            b           0    0    roles_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.roles_id_seq', 4, true);
          public          postgres    false    218            c           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 43, true);
          public          postgres    false    220            d           0    0    uzivatele_audits_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.uzivatele_audits_id_seq', 16, true);
          public          postgres    false    224            �           2606    16441    hodnoceni hodnoceni_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.hodnoceni
    ADD CONSTRAINT hodnoceni_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.hodnoceni DROP CONSTRAINT hodnoceni_pkey;
       public            postgres    false    209            �           2606    16443    komentare komentare_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.komentare
    ADD CONSTRAINT komentare_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.komentare DROP CONSTRAINT komentare_pkey;
       public            postgres    false    211            �           2606    16445    odpovedi odpovedi_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.odpovedi
    ADD CONSTRAINT odpovedi_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.odpovedi DROP CONSTRAINT odpovedi_pkey;
       public            postgres    false    213            �           2606    16447    prispevky prispevky_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.prispevky
    ADD CONSTRAINT prispevky_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.prispevky DROP CONSTRAINT prispevky_pkey;
       public            postgres    false    215            �           2606    16449    role role_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.role DROP CONSTRAINT role_pkey;
       public            postgres    false    217            �           2606    16451    uzivatele uzivatele_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.uzivatele
    ADD CONSTRAINT uzivatele_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.uzivatele DROP CONSTRAINT uzivatele_pkey;
       public            postgres    false    219            �           2606    16503 "   uzivatele_role uzivatele_role_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.uzivatele_role
    ADD CONSTRAINT uzivatele_role_pkey PRIMARY KEY (role_id, uzivatel_id);
 L   ALTER TABLE ONLY public.uzivatele_role DROP CONSTRAINT uzivatele_role_pkey;
       public            postgres    false    221    221            �           1259    16452    fki_komentare_fkey    INDEX     N   CREATE INDEX fki_komentare_fkey ON public.odpovedi USING btree (komentar_id);
 &   DROP INDEX public.fki_komentare_fkey;
       public            postgres    false    213            �           1259    16453    fki_prispevky_fkey    INDEX     P   CREATE INDEX fki_prispevky_fkey ON public.komentare USING btree (prispevek_id);
 &   DROP INDEX public.fki_prispevky_fkey;
       public            postgres    false    211            �           1259    16454    fki_roles_fkey    INDEX     L   CREATE INDEX fki_roles_fkey ON public.uzivatele_role USING btree (role_id);
 "   DROP INDEX public.fki_roles_fkey;
       public            postgres    false    221            �           1259    16455    fki_users_fkey    INDEX     P   CREATE INDEX fki_users_fkey ON public.uzivatele_role USING btree (uzivatel_id);
 "   DROP INDEX public.fki_users_fkey;
       public            postgres    false    221            �           1259    16456    fki_uzivatele_fkey    INDEX     O   CREATE INDEX fki_uzivatele_fkey ON public.komentare USING btree (uzivatel_id);
 &   DROP INDEX public.fki_uzivatele_fkey;
       public            postgres    false    211            �           1259    32867    idx_prispevky    INDEX     K   CREATE UNIQUE INDEX idx_prispevky ON public.prispevky USING btree (obsah);
 !   DROP INDEX public.idx_prispevky;
       public            postgres    false    215            �           2620    32883    uzivatele uzivatele_change    TRIGGER     |   CREATE TRIGGER uzivatele_change BEFORE UPDATE ON public.uzivatele FOR EACH ROW EXECUTE FUNCTION public.uzivatele_changes();
 3   DROP TRIGGER uzivatele_change ON public.uzivatele;
       public          postgres    false    239    219            �           2606    16457    odpovedi komentare_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.odpovedi
    ADD CONSTRAINT komentare_fkey FOREIGN KEY (komentar_id) REFERENCES public.komentare(id);
 A   ALTER TABLE ONLY public.odpovedi DROP CONSTRAINT komentare_fkey;
       public          postgres    false    211    3222    213            �           2606    16462    komentare prispevky_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.komentare
    ADD CONSTRAINT prispevky_fkey FOREIGN KEY (prispevek_id) REFERENCES public.prispevky(id);
 B   ALTER TABLE ONLY public.komentare DROP CONSTRAINT prispevky_fkey;
       public          postgres    false    211    215    3228            �           2606    16467    hodnoceni prispevky_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.hodnoceni
    ADD CONSTRAINT prispevky_fkey FOREIGN KEY (prispevek_id) REFERENCES public.prispevky(id);
 B   ALTER TABLE ONLY public.hodnoceni DROP CONSTRAINT prispevky_fkey;
       public          postgres    false    3228    215    209            �           2606    16472    uzivatele_role role_fkey    FK CONSTRAINT     v   ALTER TABLE ONLY public.uzivatele_role
    ADD CONSTRAINT role_fkey FOREIGN KEY (role_id) REFERENCES public.role(id);
 B   ALTER TABLE ONLY public.uzivatele_role DROP CONSTRAINT role_fkey;
       public          postgres    false    217    221    3230            �           2606    16477    uzivatele_role uzivatele_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.uzivatele_role
    ADD CONSTRAINT uzivatele_fkey FOREIGN KEY (uzivatel_id) REFERENCES public.uzivatele(id);
 G   ALTER TABLE ONLY public.uzivatele_role DROP CONSTRAINT uzivatele_fkey;
       public          postgres    false    221    3232    219            �           2606    16482    prispevky uzivatele_fkey    FK CONSTRAINT        ALTER TABLE ONLY public.prispevky
    ADD CONSTRAINT uzivatele_fkey FOREIGN KEY (uzivatel_id) REFERENCES public.uzivatele(id);
 B   ALTER TABLE ONLY public.prispevky DROP CONSTRAINT uzivatele_fkey;
       public          postgres    false    219    215    3232            �           2606    16487    komentare uzivatele_fkey    FK CONSTRAINT        ALTER TABLE ONLY public.komentare
    ADD CONSTRAINT uzivatele_fkey FOREIGN KEY (uzivatel_id) REFERENCES public.uzivatele(id);
 B   ALTER TABLE ONLY public.komentare DROP CONSTRAINT uzivatele_fkey;
       public          postgres    false    211    219    3232            �           2606    16492    odpovedi uzivatele_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.odpovedi
    ADD CONSTRAINT uzivatele_fkey FOREIGN KEY (uzivatel_id) REFERENCES public.uzivatele(id);
 A   ALTER TABLE ONLY public.odpovedi DROP CONSTRAINT uzivatele_fkey;
       public          postgres    false    219    213    3232            �           2606    16497    hodnoceni uzivatele_fkey    FK CONSTRAINT        ALTER TABLE ONLY public.hodnoceni
    ADD CONSTRAINT uzivatele_fkey FOREIGN KEY (uzivatel_id) REFERENCES public.uzivatele(id);
 B   ALTER TABLE ONLY public.hodnoceni DROP CONSTRAINT uzivatele_fkey;
       public          postgres    false    209    219    3232            <   ^  x�E�[��0E�o3�V��s�����J��-��Tl߽��w[��k��ֻ���E?�[����.��1���5׃���K^]��Ӽ���՝\��J��~�⣅�����g�u�/�o�u�7K�������3H�>���z��܃�4�ݧ��L@�
_`�2t��с4P$r�<�~��E�����Q� M��Ŕ�T	HNЎxY
�������W�YD�Oy���t�bw�Qq�}���Y)�l�T�шJ�5:�8@�l۪T���t���+
���=�M�S�J�sE�Q����̮����zR��#G�Ԑ* ��ာ���f����:�LP�ZN,����JPbu%(U-�ɵ��%ޭ��{(�a=k)d+
����	YCa��X���W��+|���/���K��a�!E�T�(��%E�;���h�Y��9`,������hИ
#�Y|�k���evz<G��ƌ�R7�Q'[O���\f���o�`����:5���R{�<e,������5�`6X0j����̑���τ�k~\�"��0�5H¿q�넅���b�7�L�z��mo2�1XU�qV�3O2�������?f�y;��      >   G  x�UV=��H��_�����3�+���ć �K������m�\�.>m����e'�&���מ�@��vw׫WUϛ�h����Q[�MW��]���|�vEucw_����rKxAV��<��jɈ�<V�ȑ�*�+����z����m^�U�X� �$Qz��Nx�v_���o�q�Y����B��nD'��\�/�ݥ�����x}�y�7"�GE��9E�Ђ���؄.�~�S�Res�-�~�!/�p����Z�-v��[4��� �ځ��L�Q���O������6�d�6�����ܿ��*�H��&�R��pW�n��B�$�n�@�2s^tӸ�A�it�}x�mW
�2��2-S��QڨOӘ	�	y�Jp�A�-ی!��Qf�
QZ���ՊI�����j-�/tsDZ���H�Ud�X�J�UIiϼV`~�ۣx}1�'����u�m�L�в�p���q�ڄ{%H�
9� �^zf�� ��J���:
-������r���[�'ȃ0�[��@O*z���g1�ʩ�!Ċ�	���dg�k���AU��m��b��j/�(1�e�ȟ7Dӂ��������t�^�X(L&�̨��;1�-�O�/�B���L��F�=��k���z�c|�XG/z���湋��D(�A��t�C���j�T&uBO�;'Q'
	�]���_XU7�I��b�u��z?xHK��a�0�� �����z*��;��u��Au��TB�,sZ��ڪ�#����#�{�tO2iJ�L��@�߈�ǆ�����Wd��v�'y�J�jQ���	Jm�34��ؚO-0�߿�E�(�({
���74]�B��J��Ni���{H���5
+\���Q�4rq�4x�Xŀj������	$?+�[(����|��>���E�ܥ���[���Z;�.����$���B�
�BM7�����-z�p� cm+e�L��Q�ys�J�`��"P!����b�C#�(����)��4�1�p�CR�y������X-���� �����/�Yr4Q�!#�K��������ɤ�&�̖cN��o�4d ,	��Ӛ��@"�EA+(�
47�@��m�ꇂ�1{DB�I<��^�Сt^�γ�1�2qj22U��ˀ�c�N�в��6��]t 8Kq����U�T0-V�?�����%
�ڒVc�g�_R)�Q?�$��N�w�~ː�6-��ٯX_)X:���c��G��>`��=�<�����UC䫞�b�	R~(��̽$�Sna(,w�'����*�d�u�>������҃���ϳ�7�0�����ƦZ!s�0y��ּ�e�����[Â%{V��`Ci�x=�h,�u��]��f҃��d�����a;|i����-ir_J8��;.���N�|�<��i��#�`��w�]t�43xE5ϙA��WY�y�{���l��K�gls<;�z�*>|�AoN��i�/">��|������ś3~O@B�Ҭ  ^|Y㚧P�ST���C~�$ʫ���o�_���Ǭ����O�_�~�:�~�����$��� ��+      @   �  x�mT�n�F��_�PtB��k��6|���pg���!�A�����6p�@�܀.��\M�||�.{z�����8�ɽ�G*��A��)3t���鰷���x���~�T��l+�;�D7�΅xFþ�.m��W+KӚ(s�Y��CmH�Q��&�iR~��e�C��؈u��������S�2�F�z46��N2�7�X�th�%mK/��bD��i�����ע�\t���T�: �C+q����{���:Dd/A�ӥF�kM�F(���%8y9p��e��q�݈w(�W)�&�U���*��vڦ`U�V(B[����(��j����]N�R���\��2���&ڥ�jِ���T������̮��������h�KgԨ�����Au�3����i>�9���"��DH^���J�ϯ�'_SO���Ժ�]���K
��06/�K�]���R��?Ud�a#[z3ﵗ/�B��ѻ��n������NQq�r0
���}�X"4�� ��N��Ǉ.�����F�����X�Zm�J��O����ެ[ƭㄑ�zW����P��+]�@�����V������N6�����_e%ŉ��..�Mv!�"< Z���~�(-�!����޴�X�M�?�ϱZs/!���e��ף�D
L/Y�K�P<��Q�{ɞa�z��u��lY�5Oqq���T�ܞ��V�?>�{�8�l��N׍�?b�M���V2y	�nz��)�A������P���`�i�p]��؈�\����Y�L�! ���[~���#ov�ޙ�a��$vO
�K�Cz�w�,+�h=�j:t��Y�����>,�Y3j�ba��uV��zV]���ˬ؈�q�Q+~y+�rv��
��ҥ����/����7��4?]�6�j#n߼�_���t9Y�g�b��O��p����o��y�e� (�)z      B      x��ZK�Gr>�������L7{8|^�
���(  ��r����BUVI]�=�a�=�@� ����/=�G����"�z��_Gc��̌��"⋈Z�^���fpf�]��'��ʄ�[������.KW��<���}\i:g2o��f�U^�Ԗ�i�z�~>7��'��ڥ��^U��������ah��3�j{Y_�-��z{��>�`�*lL�ⷼ��[�3a�S�ú���[:��k�(�YGI�ea�n�qn廏��C����ʙ��%o��e��\r�=�M�����GH�ռb��q�vs��r&�bL�T��gkWfV>�N�����f8��uõ3���hG�;��t���Ss��\���"���+]�����-���v��*i��!�Q#@�L�mt)�v�.�^(�*s���c*��d�=��J�e�w�춆�:�ܤy��9��z�P�P��]c���V�ܒ_���'|S�u��Olbq�!UG4�-�W8a���nSg-�W�w�1uu�擨�ƛ�gT껕�Զ����w��I��ع�랈�Ԕ��� ��{�ꆢM�۬3|Z�#bq�X�07���k�C�X i
�Ϥ+����6�~���B� ���SgVu��i�R1vy1,)��](�
�6	��ԥ�47�p�|w<6�Ѓݩ̾�L��'v�y���$N�N�<�M��F�X�!���Z�_����J�cl?��r4���>��7�۽��~��pm�2��P�J&�<>tҹ���/��́-ֈ^��j>�=���g�G��'�V-�;J7���e��Ʒ6�6֮��q:t.nN��T�P�-���C��=W-�{��gh �/��&��2��訸.�1:��7�c0�d���䆣���QK��E����r�q���ij��q�������}�#>�看�1*�}�]�S��S�����>arp�"S��)��(��Ft�rY�P��_o��3z!$t<;i��Wy%��������4��W�;���^��E���l-��-;xY�Հ¨��
�#6Ǫ�W��1�_ ��[{��&����[g+?�E����ٚdC�Nh��|A�����U
K�/�bz��
&�3#���Kܟ%�3:q椇F�I]�o���\���k4�Y�Qt�sS��>�0?;�=�	h��+��C��^�M- �h�#lX�XV9�SG$@h|�p��%�>7ϒ,`~,f�>�-���g�3����<kˍ4Ȃ��� �"VA��B��ۍi�hM���e����oLj,)r�V�}�!!A���^��_~���?��O�O��TPD9�T�����J)Vm[ރ�t��,������	��^%�5�p��F���5�RS�9PW����"�]�:X�K����� ��a�����y��	��!��)�� 2|��@�������/�����k�˧����rA媢�v�"�	2l�Y0c�s�K`�@-(�K�
��ȶ�(x�u7J\�?h�v��n�]:�®_��<b&B���)8Q����Yn�EK�j�_:��H���sڱ�	���a�b7�Q2P:J���[��8f�6X��א_#ެi%��v�)�<8:�=���?f���2�}�3CN��f�H<��&���ސ|����cM��ɶ�^�+�4豗��	�
���p�j����_���/���5h������=��K��:��s�GJoZ0T!������)���|��iܾ��\+0V��v̘��H��9ů�]nB�f%_2 gt�$���Z�h!`�E�qFs_�fs�J���\�S����d���-��ؽ�"
�N�'f�#���r��(�`�aD�ɉ:*�ϩr$�UP����穥��M�>��N�n�^�HC��
�W���FcX��#��<�~��Kp�!>��V!4��ŢoJo��y�W��v�����𯅫g��l���uūߜ�f�
H��9}0o�׳���YR&�p������{�$9�0�l� �#(H�E��]�eNJ�x�G��9#>�O�+P��P@�}��"$i�Tz
�W	���W,A�kv��RI��]��nb���<��C�A��S�dA�+�;a�^
T����V�`M#qn�~l[�|�ʐ|ʴ���2A�����ߞ�r�Ã�-h@��tY+��N�#����P��[G�f_
*|a�z���ą�	&
l��yBj� ��T�=���Kf%Y��mQ �VR�ҫ�f$�pE�GU�P�������d�bO�0}�)�]QIuX��f�E�A@�˪uOO��˼dS��1�C��5M�ZJS�$	�N�z_6�ɕ!���)�x���b���+7%=
��R1+:ȅ�[�?b���+2l(�����)��N���5����P�8\|چ�(�	�"�:�2~���jF0.o�iʜ�?@5���x�o�C|�I�ԣ25��������?	��pC1�f�!��5��~e^pE?P���N�rFB���ġ�VxPar���Ä0� B��J����n���z��邠��,6�4��ؑ�~{U	��
9�)U�<�>�ql�2�[�,	.l�r��as�����d��,r��[,�,�������Z<�ry{�ܹ��cܜ�����}�ghB1����� 3��EP�="���]�U���p�������7.�} N�y+�k�����;�g~�^C>C�<(�5�V�O�/�·ΐ+�sql��crSq����%����7�:/aw�K�|U��J�,=O�`��J}1>�u�ڗ��5C� N�O�mƶ��^���&�a3������ ����͚\�u��L/�����c5�%������c�=;z0{�œ����/�>����e�ƣ�X�^L�\���� �GI�3�ޮ��l�P��B��2�d��}�W���)��:"��g]J�������jVY��{o����ȇ�M*e�~�ڥ�SI͏ҝQ���C)]�T�P;v��[�U_
o:̣���]�Z�.)#�:c�b`PU�^�1"�i*F%K�L'�ǅ�T-�{�|Zp�!C�9��J
lR��1��T�$���ՠk�tפH]��䚰~���s�L�o�z� $@�
�hi<"9O}J-�����AQj��Ӗ�d��\���z�y��������>���뷳5�DީQ���5�U]��4b�[�,�ɁKߏ�4xYv_�)y���n�J���Ð��v�ƚQ���@��?̋�Fd��l���F�|����Y,ܿ{��sv�G�g!�d蠡ڟ��	n�O��Q���'����	R#
�:?)�2���W��T��O�ʱ��Um��{�h��=�+Q	ٳG�j�x�}�U��`�����	�I�IVy/���'۷�"PtVjS�}p���P�oJ�pX�A{�i�Is6��Β��w�� ��Q�F8��"(�$^�zĺ#�ة�E�?�>J���ʥ&�<��蔊a��܍�RiD��<��v?�s֮_��=#���[(�s=!K�`PT�}6~�m�O��)����F�˦�>�r��F'OĪF�����7��(��V4pq8Q`�Y���!a���P/L7A�.v2�
&1���"Ac�5����^2l��U��#����Il�r�Í�X`�u����Ҿ�o�#�F��i"F�2;����������G��Yoj>wl��t`siY�}��J��r�:R:K�ڲƶ0�Tt�=Z�����(
c����*��|&@i�
�7ɫk��EJ�81�H�\++���gD���s����}M���@.s�$�H
�'�y���,6R�l�ܪ�"An6bA(�e��̉ox�t���cR!�f������+7�W"��(_�lq?Kh]\��}a�a3�o�V��m*Z-'��ɪ̥7����ղ�i��U��k�s� ��4n�&����Yp��8��f:��g�[��;Bg�c}�F���K����E9L�z���M<��s�	������1*�ˀ
���Xm'�p�T�O0����r�C��xR��49 �  ;��o���Q��<0�S�GW�D9')�FDtL8[��^:�:�ei"�wH�M�BG!�_�'E��*����y�o%��_4�#�]��=����3{SKT=���|�}⁹𠀝@� ��:�>���&�� �-o�˯$�_�E���%R�B�vbI�i�\����k�2r�eu�*7�(s4��4������:�q*|���I.�Uu^�r��Z�]H��qg�t�� ��;�����`XV�bj��SSIF-�2����K޸�G���MXa�J��w��E$��9�T�H�2X2p������e���PY� ��I����/7�2mg��f�IJ�C�FVI/9"���ڀ�n�L�q��������)�É��Dt��<�Ju�A��酖�&�Y���*��}<��w�M�L'���D�K�1�#⤑�&x5tG6���A������� ���IL>��$g�m��&;	���·��g �Mgc�O2�A�w��������Mo9���wlN��n$QK�nrNy�E�i��j����'`�8����B'50������p"_�"7�ͦ�Qt+n�ËǓpndc��Ց<��_���Oqd0Կ��_;s ���m�L��#�YllL�&:��A�I��Y~�lAx0����qS�$	���|�PV�o����g.�l����	����4��Ɗ�j"����ܹ^�eVx����0�>c�7'��ul��D�P�'%����?����[����x�������;���ۯh�����,��! ����*�P��x,�[�NJ-�Vd7�����gɓ�66p!�����!��MT��򤜻�q���҉��#�������8���ŔK,:-
�o|/ �;Zqr>n/��Y��0��J�/���� �m,04��sD���})c�_0rL"7�
��ɐ���i�}��U�r�}$��N�-A����v1B�r�وcwb��R���͙�,�x�N�`T2MY��z]:X:�R�ï̷R�J�����ũ~�3l��2������t��h��y��r4�B�vs��8A1IŮP�I[h�k&R:r
���:�����wf/I��(�<67�3Ü�RT-H�������7FV��L�A��E����
[�7xBˉ�P�����|{�_#-k�S����R�eN�6��#�B�(×:<*mx~-�����J��]��k�E��ah����I�0�� l���eq[Hv)RDuD՗�^�(mM.��S;���e�s�x���$x�����v���{ʪ%��;����XkŁK�&�ZP��&�12�)fD�����Ƀ&�N��8ޗ�T�22멖#U���1eO䉑����A�4 Ŋ��KP�7�Z6�ר�e�\�8�Ҁ�����MSs��D)�v
d���y�0=�\Hٵ����|���Nߚ8|�R��3hi���V�T	3�d>����⸩��,��˄x��8'�~�hydt|?���~d�����p����"��*Y���^�#w���֫�W��}k��3A-�ߺ��x�<5;�{��e;���`���:]��,}���c�wR�^rS�����Tw�&=ȏ$��t��������b�޷.�,�{���irwqq79���=p�gg�Nf��{y�������٭�N����]v���72)+�{�����WAMC      D   4   x�3�,��,K,I��2���OI-J,�/�2�LL����2��M�����qqq _+�      F   W  x�mV�n+I<�?FH&s��C���2O�d�-���O��WF7��Lc��]��_'y?��1�J�r�%���j�#�4T�싨�bm�E�Y��mD�ڷ�/���]�x>���Dy{���"7�JP��تK_Z�*�^sZ��Z֧���c2i���0��ڵ��z~�?_�r�?�0@�~>�n�˦�)�$�RT�2�5�J�]�t�s�S���יf�y�k7�����x�����7i&�����7�uy�b�V-=�J��#^�TR��^��f%��1U�u�����z��VIyzZ��ʃ���W�RW"J��ݨ9w���$ɵ�,j��v{��~�8\�6�� �R�s����/�#\�H��8�\4�^�Qj�RN�?�x�Οv?��~��iitm�S�i�b�ꪕ-��-�������l��du�?�?_��1fl/�w(�,k��G��PHϜ��hD]��m1�d���g(+�e9����`�]�vo�!�$��n�K��{���H�b�C����A�آD�4p�u�����v#(m7�u����!� T��( ��[&�>��9{��ƴ��+[��*/x܃��G���7��ʶjf�L�H��Czvu�L�Aq��v����׀����ξ���=�!�������m#��&.�'KΊ�j�34��82z�V|T�Z�X:^$�V~�=��<G��~M*ۋ�>��~V?mE#�JӴtB� �Tl�g�5!�X�l<�z#^<s���=��Ӿ�|���m�+�,$֒Y<��2l�p��������٤P��p>v>/�f�h�����A}��9�7$��������Zoٚ�ސ��!^��a%o\f	]�x���9�'�^}?�}�__>\mm�	C`�6�*u1Μ5rG�ך8V���(�5��}@�~��U=�ף^�~�\_E��s	��`�
�"�$*�8N�P�AA��t8�e��c����������������;��Hb6��,֤�k`:N7�s-�Ȥ{n,�jCU4��������7Lھ7E�<�4��T��(�-��eK���Q&
+�>��(�[��p�C���n�_oW�?]���%m�(�^M��L4
!�f5�rŻ�����H�*��;�~���(m��,7$���.Y B��L�fC�D�B�2�2j�"'��-��
��4��0�[��?I��P�xDZ ؐc�Hȡ�E�R��.����ɰ���\�O�{a~'��#�Q��&*����mY�G[e<`���R[��v!����]��{6�|����#9�WM���c��4��;pB�4jB�Z{������@��N�XLSTS/�U|��h�%5PV+���2�5��'����M�k7�������      J   �  x�핱V1E��W��H�,�S�!i<����B�I��ǻ){�XHC3͜yWz�<����0<��}],�����V��!�[s��Aj�m�Ī�kN��ѺWCo�0�s���xz��؞J׀א�W�,�$�h�e_�]���%��M��(i�������
E7D�[j��ںtusŬ��n����}l��?��5�1e+�˃/�<8y�.]�I�xs�����+�5њ%f5����Қ8Z�s���	y��
r�
N:�ז�7]�#`H�(����˴%ا7�+����EB9��f�|��
����*j 6�a��g��Tݺ�Ak�2���3��C�9x�>�yN+`Ԓp����7���+�/��h>[�K_�����CJ�V�+���x^Kɕs!`"/�Q�����7��=�;z��0qu��u�/+p��R^<�ޤ�˵b��ix����ݢy�x�2OW,f�)|�!�_���X      H   Y   x����0ߦ�L �^�=X3 �g�v�8�5^#e-k[�J��P�TLǔ�7&�~�P���g��1+�m��E�>��] ~^.�     