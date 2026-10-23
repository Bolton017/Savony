-- transfert a annuler
UPDATE mvtstock SET etat=0
WHERE idtransfert IN (
      'TS001185',
      'TS001290',
      'TS001289',
      'TS001270',
      'TS001269',
      'TS001266',
      'TS001264',
      'TS001263',
      'TS001262',
      'TS001240',
      'TS001239',
      'TS001235',
      'TS001228',
      'TS001238',
      'TS001236'
    )