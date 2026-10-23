ALTER TABLE as_bondecommande
ADD (
    service VARCHAR2(255),
    echeance NUMBER,
    dateEcheance DATE
);