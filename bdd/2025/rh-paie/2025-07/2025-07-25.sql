-- delete personnel non valide
DELETE FROM log_personnel_non_valide

-- udpate CIN
UPDATE LOG_PERSONNEL SET numero_cin = '103112021426' WHERE nom = 'RAMAMONJISOA' AND prenom = 'Nambininiaina Giannah';
UPDATE LOG_PERSONNEL SET numero_cin = '101222111268' WHERE nom = 'RAMIARINDRAIBE' AND prenom = 'Emma';
UPDATE LOG_PERSONNEL SET numero_cin = '103052014196' WHERE nom = 'RAMANANDRAITSIORY' AND prenom = 'Harilala Nadia';
UPDATE LOG_PERSONNEL SET numero_cin = '103132020703' WHERE nom = 'RAHAJARIVONY' AND prenom = 'Tantely Hasina';
UPDATE LOG_PERSONNEL SET numero_cin = '101982101185' WHERE nom = 'RASOLOFOMANANA' AND prenom = 'Haingonirina Jacqueline';
UPDATE LOG_PERSONNEL SET numero_cin = '715012026796' WHERE nom = 'ANJARASOA' AND prenom = 'Fridolina';
UPDATE LOG_PERSONNEL SET numero_cin = '301991069530' WHERE nom = 'RABEMANANTSOA' AND prenom = 'Louis';
UPDATE LOG_PERSONNEL SET numero_cin = '101242195125' WHERE nom = 'ANDRIAMPAMENONTSOA' AND prenom = 'Finaritra Diamondra';
UPDATE LOG_PERSONNEL SET numero_cin = '102392006476' WHERE nom = 'RANDRIANALIVELO' AND prenom = 'Hajamalala Carine';
UPDATE LOG_PERSONNEL SET numero_cin = '101232179435' WHERE nom = 'ANDRIANANTENAINA' AND prenom = 'Anais Rubis Fanou';
UPDATE LOG_PERSONNEL SET numero_cin = '715011025950' WHERE nom = 'TOLIMANA' AND prenom = 'Landry';
UPDATE LOG_PERSONNEL SET numero_cin = '101212265295' WHERE nom = 'RAZANAMAHEFA' AND prenom = 'Tohy Nokaliana';
UPDATE LOG_PERSONNEL SET numero_cin = '107011008104' WHERE nom = 'RATSIMANDRESY' AND prenom = 'Nirina Hery Zo';
UPDATE LOG_PERSONNEL SET numero_cin = '118071006123' WHERE nom = 'RAKOTOARISOA' AND prenom = 'Lovanirina';
UPDATE LOG_PERSONNEL SET numero_cin = '101252193297' WHERE nom = 'NIRINA' AND prenom = 'Lily Eliane';
UPDATE LOG_PERSONNEL SET numero_cin = '101251177472' WHERE nom = 'RAKOTOARIVONY' AND prenom = 'Anja Manampisoa';
UPDATE LOG_PERSONNEL SET numero_cin = '101981092524' WHERE nom = 'RAHARISON' AND prenom = 'Anja Luciano';
UPDATE LOG_PERSONNEL SET numero_cin = '117012043101' WHERE nom = 'ANDRIAMIRAVO' AND prenom = 'Volantsoa Setra Fitiavana';
UPDATE LOG_PERSONNEL SET numero_cin = '103132020667' WHERE nom = 'SANTATRINIAINA' AND prenom = 'Olivia Laurencia';
UPDATE LOG_PERSONNEL SET numero_cin = '103112026873' WHERE nom = 'RAJOHANESA' AND prenom = 'Zohasimino Erica Kelly';
UPDATE LOG_PERSONNEL SET numero_cin = '101232174743' WHERE nom = 'RABENANDRASANA' AND prenom = 'Miantsaly Nombana';
UPDATE LOG_PERSONNEL SET numero_cin = '101212253480' WHERE nom = 'MANOVOSOA MANDOLINA' AND prenom = 'Michelle';
UPDATE LOG_PERSONNEL SET numero_cin = '117071021768' WHERE nom = 'RASAMISON' AND prenom = 'Tolojanahary Tanteliniaina Michael';
UPDATE LOG_PERSONNEL SET numero_cin = '103112026688' WHERE nom = 'RASAMISON' AND prenom = 'TOLOJANAHARY Haingo Mitia';
UPDATE LOG_PERSONNEL SET numero_cin = '313012033297' WHERE nom = 'RAKOTOSON' AND prenom = 'Fanomezantsoa Johanna';
UPDATE LOG_PERSONNEL SET numero_cin = '117122015714' WHERE nom = 'ANDRIALALANIVO' AND prenom = 'Mirantosoa Finaritra';
UPDATE LOG_PERSONNEL SET numero_cin = '102032036686' WHERE nom = 'RANDRIATEFIARISON' AND prenom = 'Hasiniaina Jessica';


-- mbola mila ampidirina
UPDATE LOG_PERSONNEL SET numero_cin = '103072018982' WHERE nom = 'RAMANANTENASOA' AND prenom = 'Ravakiniaina Clara';
UPDATE LOG_PERSONNEL SET numero_cin = '101222082256' WHERE nom = 'RAZAFIMANANTSOA' AND prenom = 'Faramihanta Annie';

-- inexistant dans donnees XC :
--> PRS000087 DIAVOLANA Fanomezantsoa Véronique
DELETE FROM LOG_PERSONNEL WHERE id = 'PRS000087';

-- employe tsy mety fa nisy diso
DELETE FROM log_personnel WHERE id = 'PRS000094';

-- udpate sexe selon 6eme numero CIN
UPDATE LOG_PERSONNEL
SET sexe = CASE SUBSTR(numero_cin, 6, 1)
   WHEN '1' THEN 1
   WHEN '2' THEN 0
   ELSE NULL
END

-- paie_fonction
DELETE FROM PAIE_FONCTION WHERE id = 'null';
DELETE FROM PAIE_FONCTION WHERE id = '-';

-- groupe fonction
DELETE FROM PAIE_GROUPEFONCTION WHERE id = 'PAI000001';

-- manadio service
DELETE FROM LOG_SERVICE WHERE id != 'SERV00001';

-- manadio
DELETE FROM DEMANDE d;
DELETE FROM MOUVEMENTABSENCE m;
DELETE FROM paie_info_personnel
WHERE id NOT IN (
    SELECT id FROM log_personnel
    WHERE id IS NOT NULL
);
DELETE FROM SANCTION;