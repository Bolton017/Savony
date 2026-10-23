create view FABRICATIONCPLATELIER as
SELECT
    f.*,
    ai.ATELIER,
    ai.id as idingredients
FROM FABRICATIONCPL f
left join FABRICATIONFILLE ff on ff.IDMERE = f.ID
left join as_ingredients ai on ai.ID = ff.IDINGREDIENTS;