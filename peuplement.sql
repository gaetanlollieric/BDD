WbImport -file=/home/etuinfo/glollieric/Documents/BDD/partie2/v_candidatures.csv 
         -Table=_individu
         -schema= partie2
         -delimiter=';' 
         -header=true 
         -fileColumns = $wb_skip$, $wb_skip$, $wb_skip$, nom, prenom, sexe, date_naissance, nationalite, code_postal, ville, $wb_skip$, $wb_skip$, $wb_skip$, ine
         -dateFormat='yyyy-MM-dd' 
;



CREATE table _candidature_temporaire(
    ine char(11),
    dominante varchar(100),
    specialite varchar(100),
    serie varchar(100),
    mois_annee_obtention_bac char(40)
);


create table _inscription_tempo(
    cat_socio_etu varchar(100),
    cat_socio_parent varchar(100),
    ine char(11),
    code_nip char(11),
    bourse_sup varchar(100),
    mention varchar(100)
);

WbImport -file=/home/etuinfo/glollieric/Documents/BDD/partie2/v_inscriptions.csv
    -type=text
    -delimiter=';'
    -header=true
    -table=_inscription_temp
    -filecolumns=$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,code_nip,ine,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,cat_socio_etu,cat_socio_parent,$wb_skip$,mention,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,bourse_sup
;


WbImport -file=/home/etuinfo/glollieric/Documents/BDD/partie2/v_candidatures.csv 
    -type=text
    -delimiter=';'
    -header=true
    -table=_candidature_temp
    -filecolumns=$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,ine,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,serie,dominante,specialite,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,mois_annee_obtention_bac
;


ALTER TABLE _etudiant ALTER COLUMN serie_bac DROP NOT NULL;

INSERT INTO _etudiant (
    code_nip,
    cat_socio_etud,
    cat_socio_parent,
    bourse_superieur,
    mention_bac,
    serie_bac,
    dominante_bac,
    specialite_bac,
    mois_annee_obtention_bac,
    ine
)
         
SELECT DISTINCT
    ins_t.code_nip,
    ins_t.cat_socio_etu,
    ins_t.cat_socio_parent,
    ins_t.bourse_sup,
    ins_t.mention,
    can_t.serie,
    can_t.dominante,
    can_t.specialite,
    can_t.mois_annee_obtention_bac,
    ins.ine

         
FROM _inscription_tempo ins_t
JOIN _candidature_temporaire can_t ON i.ine = c.ine
ON CONFLICT (code_nip) DO NOTHING;


SELECT * from _etudiant;

--module

WbImport -file=/home/etuinfo/letessier/Documents/BDD/data/ppn.csv
-Table=_module
-schema=partie2
-delimiter=';'
-header=true
-fileColumns=id_module,ue,libelle_module;


--semestre

DROP TABLE IF EXISTS temp_semestre CASCADE;
Create TEMP table temp_semestre
(
   num_semestre  varchar(5)   NOT NULL,
   annee_univ    char(9)      NOT NULL
);

Create TEMP table temp_semestre2 AS SELECT DISTINCT * FROM temp_semestre ;
select * from temp_semestre2

WbImport -file=/home/etuinfo/letessier/Documents/BDD/data/v_programme.csv
-Table=temp_semestre
-schema=pg_temp_17
-delimiter=';'
-header=true
-fileColumns=annee_univ,num_semestre;

INSERT INTO partie2._semestre(annee_univ,num_semestre)
SELECT annee_univ,num_semestre
FROM temp_semestre2

