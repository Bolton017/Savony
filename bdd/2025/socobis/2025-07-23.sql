CREATE OR REPLACE VIEW STOCKETDEPENSEFABNC AS 
select mvt.IDOBJET, fille.IDPRODUIT,cast(sum(ENTREE) as number(15,2)) as entree, cast(sum(SORTIE) as number(15,2)) as sortie, cast(avg(fille.pu) as number(30,2)) as pu,
cast(nvl(avg(fille.pu)*sum(entree),0) as number(30,3)) as montantentree,cast(nvl(avg(fille.pu)*sum(sortie),0) as number(30,3)) as montantsortie,ofille.IDMERE,ofille.id, cat.id AS CATEGORIEINGREDIENT, cat.val AS CATEGORIEINGREDIENTLIB
from MVTSTOCKFILLE fille
left join MvtStockLib mvt on fille.IDMVTSTOCK=mvt.ID
left join FABRICATION fab on mvt.IDOBJET=fab.ID
left join OFFILLE ofille on fab.IDOFFILLE=ofille.ID
left join AS_INGREDIENTS ai on fille.IDPRODUIT=ai.id
LEFT JOIN CATEGORIEINGREDIENT cat ON cat.id = ai.CATEGORIEINGREDIENT 
where mvt.ETAT>=11  and ai.COMPOSE=0
group by fille.IDPRODUIT,mvt.IDOBJET,ofille.IDMERE,ofille.id,ai.COMPOSE, cat.id, cat.val
union all
select c.IDFABRICATION as idobjet,c.IDINGREDIENTS as IDPRODUIT,cast(0 as number(15,2)) as entree,cast(sum(c.qte) as number (15,2)) as sortie,cast(avg(c.PU) as number(30,2)) as pu,cast(0 as number(30,3)) as montantentree,cast(nvl(avg(c.pu)*sum(c.qte),0) as number(30,3)) as montantsortie
,ofile.IDMERE,ofile.id, cat.id AS CATEGORIEINGREDIENT, cat.val AS CATEGORIEINGREDIENTLIB
from charge c
left join fabrication fabb on c.IDFABRICATION=fabb.id
left join OFFILLE ofile on fabb.IDOFFILLE=ofile.ID
LEFT JOIN AS_INGREDIENTS ai ON c.IDINGREDIENTS = ai.id
LEFT JOIN CATEGORIEINGREDIENT cat ON cat.id = ai.CATEGORIEINGREDIENT 
where c.etat>=11 group by c.IDFABRICATION, c.IDINGREDIENTS,ofile.IDMERE,ofile.id, cat.id, cat.val
UNION all
select 
    h.IDFABRICATION as idobjet,
    'IG000364' as IDPRODUIT,
    cast(0 as number(15,2)) as entree,
    CAST(
        NVL(
            CASE 
                WHEN h.TEMPORAIRE = 0 THEN h.MN + h.JF + h.HD + h.IF + h.HEURENORMALE
                ELSE h.HS + h.MN + h.JF + h.HD + h.IF
            END,
        0) AS NUMBER(15,2)
    ) AS sortie,
    cast(rsfab.TAUXHORAIRE as number(30,2)) as pu,
    cast(0 as number(30,3)) as montantentree,
    cast(nvl(h.MONTANT, 0) as number(30,3)) as montantsortie,
    off.IDMERE,
    off.ID,
    'CATING000001' as CATEGORIEINGREDIENT,
    'Charge personnelle' as CATEGORIEINGREDIENTLIB
from HEURESUPFABRICATION h
left join FABRICATION f on h.IDFABRICATION = f.ID
left join OFFILLE off on f.IDOFFILLE = off.ID
left join RESSOURCEPARFABRICATIONCOMPLET rsfab ON rsfab.IDRESSOURCE = h.IDRESSPARFAB
where h.ETAT >= 11;