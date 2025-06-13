WbImport -file=/home/etuinfo/glollieric/Documents/BDD/partie2/v_candidatures.csv 
         -Table=_individu
         -schema= partie2
         -delimiter=';' 
         -header=true 
         -fileColumns = $wb_skip$, $wb_skip$, $wb_skip$, nom, prenom, sexe, date_naissance, nationalite, code_postal, ville, $wb_skip$, $wb_skip$, $wb_skip$, ine
         -dateFormat='yyyy-MM-dd' 
;



CREATE table _candidature_temp(
    ine char(11),
    dominante varchar(100),
    specialite varchar(100),
    serie varchar(100),
    mois_annee_obtention_bac char(40)
);


create table _inscription_temp(
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
    i.code_nip,
    i.cat_socio_etu,
    i.cat_socio_parent,
    i.bourse_sup,
    i.mention,
    c.serie,
    c.dominante,
    c.specialite,
    c.mois_annee_obtention_bac,
    i.ine
FROM _inscription_temp i
JOIN _candidature_temp c ON i.ine = c.ine
ON CONFLICT (code_nip) DO NOTHING;


SELECT * from _etudiant;
