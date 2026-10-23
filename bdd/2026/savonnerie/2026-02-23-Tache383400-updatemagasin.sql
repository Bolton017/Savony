UPDATE MAGASIN2
SET 
    VAL = TRIM(
            REGEXP_REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(VAL,'biscuiterie',''),
                       'confiserie',''),
                       'Bisc',''),
                       'Conf',''),
                       'central',''),
                       'transit',''),
                       'Transit',''),
                       'Pate',''),
            '\s+',' ')
          ),

    DESCE = TRIM(
              REGEXP_REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(DESCE,'biscuiterie',''),
                       'confiserie',''),
                       'Bisc',''),
                       'Conf',''),
                       'central',''),
                       'transit',''),
                       'Transit',''),
                       'Pate',''),
              '\s+',' ')
            );
