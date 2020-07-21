# EXOS INTERROGATIONS AVANCEES
USE sakila;


#1-Afficher tous les emprunt ayant été réalisé en 2006. Le mois doit être écrit en toute lettre et le résultat doit s’afficher dans une seul colonne.
SET lc_time_names = 'fr_FR';
select *, 
	concat(
    day(rental_date),
    ' ', 
    CASE MONTH(rental_date)
         WHEN 1 THEN 'janvier'
         WHEN 2 THEN 'février'
         WHEN 3 THEN 'mars'
         WHEN 4 THEN 'avril'
         WHEN 5 THEN 'mai'
         WHEN 6 THEN 'juin'
         WHEN 7 THEN 'juillet'
         WHEN 8 THEN 'août'
         WHEN 9 THEN 'septembre'
         WHEN 10 THEN 'octobre'
         WHEN 11 THEN 'novembre'
         ELSE 'décembre'
	END, 
    ' ', 
    year(rental_date)) as cas_du_case,
    concat(day(rental_date),' ',MONTHNAME(rental_date),' ',year(rental_date)),
    DATE_FORMAT(rental_date, '%d %M %Y')
from rental
where year(rental_date) = 2006 ;

#2-Afficher la colonne qui donne la durée de location des films en jours
select *, datediff(return_date, rental_date) as duree_location
from rental;

#3-Afficher les emprunts réalisés avant 1h du matin en 2005. Afficher la date dans un format lisible.
select *,DATE_FORMAT(rental_date, '%d %M %Y')
from rental
where year(rental_date) = 2005
and TIME(rental_date) < '01:00:00';

#4-Afficher les emprunts réalisé entre le mois d’avril et le moi de mai. La liste doit être trié du plus ancien au plus récent.
select * 
from rental
where month(rental_date) in (4,5)
order by rental_date;

#5- Lister les film dont le nom ne commence pas par le «Le».
select title 
from film
where title not like 'Le%';


#6- Lister les films ayant la mention «PG-13» ou «NC-17». Ajouter une colonne qui affichera «oui» si «NC-17» et «non» Sinon.
select	*, 
		case rating
			when 'NC-17' then 'oui'
            else 'non'
		end as 'oui ou non'	
from film
where rating in ('PG-13','NC-17');

#7-Fournir la liste des catégorie qui commence par un ‘A’ ou un ‘C’. (Utiliser LEFT).
select * 
from category
where LEFT(name,1) in ('A','C');

#8-Lister les trois premiers caractères des noms des catégorie. 
select LEFT(name,3)
from category;

#9-Lister les premiers acteurs en remplaçant dans leur prenomles E par des A.
select *, replace(first_name,'E','A') as modified_first_name
from actor
LIMIT 100;

#EXOS JOINTURES

use sakila;
#1-Lister les 10 premiers films ainsi que leur langues
select film.title, language.name
from film
join language on film.language_id=language.language_id
order by film.film_id 
limit 10;

#2-Afficher les film dans les quel à joué «JENNIFER DAVIS» sortie en 2006
use sakila;
select film.title
from actor join film_actor
on actor.actor_id=film_actor.actor_id
join film on film.film_id=film_actor.film_id
where actor.last_name='DAVIS'
and actor.first_name='JENNIFER'
and film.release_year=2006;

#3-Afficher le noms des client ayant emprunté «ALABAMA DEVIL»
select customer.first_name, customer.last_name, film.title
from customer join rental 
on customer.customer_id=rental.customer_id
join inventory on inventory.inventory_id=rental.inventory_id
join film on film.film_id=inventory.film_id
where film.title = 'ALABAMA DEVIL';


#4-Afficher les films louer par des personne habitant à «Woodridge». Vérifié s’il y a des films qui n’ont jamais été emprunté.
select film.title, city.city
from customer join rental
on customer.customer_id=rental.customer_id
join inventory on inventory.inventory_id=rental.inventory_id
join film on film.film_id=inventory.film_id
join address on address.address_id=customer.address_id
join city on city.city_id=address.city_id
where city.city='Woodridge';

select film.title
from film join inventory
on film.film_id=inventory.film_id
left join rental 
on rental.inventory_id=inventory.inventory_id
where rental_id is null;

#5-Quel sont les 10 films dont la durée d’emprunt à été la plus courte ?
select title,
datediff(return_date, rental_date) as duree_location
from rental join inventory
on rental.inventory_id=inventory.inventory_id
join film on film.film_id=inventory.film_id
where datediff(return_date, rental_date) is not null
order by duree_location
limit 10;

#6-Lister les films de la catégorie «Action» ordonnés par ordre alphabétique.
select film.title, category.name
from film join film_category
on film.film_id=film_category.film_id
join category 
on category.category_id=film_category.category_id
where name='Action'
order by title;


#7-Quel sont les films dont la duré d’emprunt à été inférieur à 2 jours
select title,
datediff(return_date, rental_date) as duree_location
from rental join inventory
on rental.inventory_id=inventory.inventory_id
join film on film.film_id=inventory.film_id
where datediff(return_date, rental_date)<2
order by duree_location;
