drop schema procstock;
create schema if not exists procstock default character set 'utf8' ;
use procstock;

# Modèle
create table departement
(
	nom varchar(30),
    taille integer,
    primary key(nom)
);

create table employe
(
	id integer auto_increment,
    no integer, 
    nom varchar(30),
    salaire float,
    nom_departement varchar(30),
    primary key(id),
    foreign key(nom_departement) references departement(nom)
);

# Procédures & Triggers
delimiter | 
drop trigger if exists incrementer_taille_departement |
create trigger incrementer_taille_departement after insert
on employe for each row
begin
	declare nouvelle_taille integer;
    set nouvelle_taille = (select taille from departement where departement.nom = new.nom_departement) + 1;
	update departement
		set taille = nouvelle_taille
        where departement.nom = new.nom_departement;
end | 