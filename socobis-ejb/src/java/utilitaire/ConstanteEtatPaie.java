/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utilitaire;

public class ConstanteEtatPaie {

    public static final int etatNotificationLue = 2;
    public static final int etatNotificationNonLue = 1;
    public static final int etatMarcheVise = 15;
    private static final int etatLivraison = 20;
    private static final int etatAnnuler = 0;
    
    private static final int etatValiderParManager = 5;
    private static final int etatRefuserParManager = 4;

    private static final int etatCreer = 1;
    public static final int etatDesactiver = -1;

    public static int getEtatDesactiver() {
        return etatDesactiver;
    }

    /* malades*/
    private static final int etatMalade = 2;
    private static final int etatPositif = 3;
    private static final int etatGueri = 4;

    public static final int etatPreValide = 10;

    /* fin malades*/

    public static int getEtatMalade() {
        return etatMalade;
    }

    public static int getEtatPositif() {
        return etatPositif;
    }

    public static int getEtatGueri() {
        return etatGueri;
    }

    private static final int etatDossierRecue = 2;
    public static final int constanteEtatFinaliser = 4;
    private static final int etatSituationdroitSuspendue = 8;
    private static final int etatSituationdroitBloquer = 9;
    private static final int etatCloture = 9;
    private static final int etatOvCloture = 9;
    private static final int etatTefCloture = 9;
    private static final int etatTefRejeter = 10;
    private static final int etatRejeter = 10;
    private static final int etatObjetRejeter = 10;
    private static final int etatRejetSupOp = 10;
    private static final int etatObjetValider = 11;
    private static final int etatImmoCondamne = 20;
    private static final int etatImmoCede = 30;
    private static final int etatValider = 11;
    private static final int etatValiderSupOp = 11;
    private static final int etatValiderSupOv = 11;
    private static final int etatValiderSupTef = 11;
    private static final int etatEcritureValider = 11;
    private static final int etatSituationdroitOK = 11;
    private static final int etatOpInclusOvCree = 12;
    private static final int etatEcritureGenerer = 15;
    private static final int etatEcritureCessionGenerer = 16;
    private static final int etatDemandePriseEnChargeDejaPrise = 17;
    private static final int etatDemandeConsultationDejaConsulte = 17;
    private static final int etatSituationdroitRappel = 18;
    private static final int etatOpInclusOvCloture = 19;
    private static final int etatTefEnCasOvCloturer = 19;
    private static final int etatOpInclusOvRejeter = 20;
    private static final int etatTefEnCasOpRejeter = 20;
    private static final int etatDnok = 21;
    private static final int etatOpInclusOvValide = 21;
    public static final int etatExpedition = 21;
    private static final int etatTefEnCasOpValider = 21;
    private static final int etatFinPlacement = 22;
    private static final int etatSituationdroitSuspensionAutoPMD = 28;
    private static final int etatTefEnCasOvRejeter = 30;
    private static final int etatTefEnCasOvValider = 31;
    private static final int etatSituationdroitSuspensionAutoBAF = 38;
    private static final int etatTalonDNOk = 41;
    private static final int etatTalonVentillationValider = 21;
    private static final int etatSituationdroitSuspensionAutoCIE = 48;
    //private static final int etatPaye = 51;
    private static final int etatTefFictif = 61;
    private static final int etatEcritureContre = 100;
    private static final int etatPensSusp = 8;
    //private static final int etatDemandeCreer=1;
    private static final int etatDemandeEnvoye = 3;
    private static final int etatDemandeRecue = 5;
    private static final int etatDemandeVise = 7;
    private static final int etatDemandeLivre = 9;
    private static final int etatDemandeAccepte = 11;

    private static final int etatDemandeLivraisonPrepare = 3;
    private static final int etatDemandeLivraisonEnvoye = 5;
    private static final int etatDemandeLivraisonRecue = 11;

    public static final int etatProforma = 8;
    public static final int etatBCTefCreer = 17;
    private static final int etatOvInclusTitreValider = 21;
    private static final int etatOvInclusTitreRejeter = 20;
    private static final int etatOvInclusTitreCree = 12;
    private static final int etatOpInclusTitreRejeter = 30;
    private static final int etatOpInclusTitreValider = 31;
    private static final int etatOpRecuParLeBeneficiaire = 31;
    private static final int etatOpMdpEspeceVerifier = 13;
    private static final int etatOpMdpEspeceValiderService = 23;
    public static final int etatPayer = 51;
    public static final String ETAT_PAYE = "PAYE";
    public static final String ETAT_NON_PAYE = "NON PAYE";
    public static final String ETAT_LIVRE = "LIVRE";

    public static final int etatDQEValide = 13;

    private static final int etatValiderParDG = 11;
    private static final int etatRefuserParDG = 10;
    private static final int etatValiderParDE = 9;
    private static final int etatRefuserParDE = 8;
    private static final int etatValiderParRH = 11;
    private static final int etatRefuserParRH = 10;
    private static final int etatValiderParCH = 5;
    private static final int etatRefuserParCH = 4;
    private static final int etatValiderParDemandeur = 3;
    private static final int etatRefuserParDemandeur = 2;
    /* demande conge */
    public static int getEtatValiderParDG() {
        return etatValiderParDG;
    }

    public static int getEtatRefuserParDG() {
        return etatRefuserParDG;
    }

    public static int getEtatValiderParDE() {
        return etatValiderParDE;
    }

    public static int getEtatRefuserParDE() {
        return etatRefuserParDE;
    }

    public static int getEtatValiderParCH() {
        return etatValiderParCH;
    }

    public static int getEtatRefuserParCH() {
        return etatRefuserParCH;
    }

    public static int getEtatValiderParDemandeur() {
        return etatValiderParDemandeur;
    }

    public static int getEtatRefuserParDemandeur() {
        return etatRefuserParDemandeur;
    }

    public static int getEtatValiderParRH() {
        return etatValiderParRH;
    }

    public static int getEtatRefuserParRH() {
        return etatRefuserParRH;
    }

    /*Paie et RH*/
    public static int paieinfopersonnelDebauche = -2;

    public static int getEtatLivraison() {
        return etatLivraison;
    }

    public static int getPaieInfoPersonnelDebauche() {
        return paieinfopersonnelDebauche;
    }

    public static int getEtatDQEValide() {
        return etatDQEValide;
    }

    public static int getEtatPretretour() {
        return etatPretretour;
    }

    public static void setEtatPretretour(int etatPretretour) {
        ConstanteEtatPaie.etatPretretour = etatPretretour;
    }

    public static int getEtatOpMdpEspeceVerifier() {
        return etatOpMdpEspeceVerifier;
    }

    public static int getEtatOpMdpEspeceValiderService() {
        return etatOpMdpEspeceValiderService;
    }
    private static final int etatOpMdpEspeceValiderSup = 33;

    public static int getEtatOpMdpEspeceValiderSup() {
        return etatOpMdpEspeceValiderSup;
    }
    private static int etatPretretour = 100;

    public static int getEtatOpRecuParLeBeneficiaire() {
        return etatOpRecuParLeBeneficiaire;
    }
    private static final int etatOpInclusTitreCreer = 32;
    private static final int etatOpRetournee = 41;
    public static final int etatOvValideSmsEnvoye = 61;

    public static int getEtatOpRetournee() {
        return etatOpRetournee;
    }

    private static final int etatTefInclusTitreValider = 41;
    private static final int etatTefInclusTitreRejeter = 40;

    private static final int etatVehiculeDisponible = 0;
    private static final int etatVehiculeMaintenance = 1;
    private static final int etatVehiculeEnDeplacement = 2;

    private static final int etatPlanningEntretienNonRealise = 0;
    private static final int etatPlanningEntretienRealise = 1;

    private static final int etatImmoRemiseMagasin = 16;
    public static final int paiePersonnelDebauche = 12;
    public static final int paiePersonnelDeces = 13;
    public static final int paiePersonnelDemission = 14;
    public static final int paiePersonnelRenvoi = 15;
    public static final int paiePersonnelRetraite = 16;
    public static final int paiePersonnelSuspension = 17;

    public static final int paieRubriqueCreer = 1;
    public static final int paieRubriqueValider = 11;
    public static final int paieRubriqueAnnuler = 0;

    private static final int etatretourner = 16;
    private static final int etatReleveConstater = 20;
    private static final int etatRDeclarationConstater = 20;
    private static final int etatORPaye = 20;

    private static final int etatCmViseParDg = 9;
    private static final int etatCmViseParDc = 11;
    private static final int etatCmEnregistre = 15;
    private static final int etatJournalFermer = 15;
    private static final int etatGrandLivreDejaRepporte = 15;
    private static final int etatDossierRetourne = 8;

    private static final int etatTVACloturee = 9;

    private static final int etatArchiveDetruiser = 0;
    private static final int Etatdispatcher = 12;
    private static final int etatNonRecue = -1;
    private static final int etatEvalue = 9;
    private static final int etatCourrierRetourner = 30;
    private static final int etatCourrierRecu = 31;
    private static final int etatCourrierEntrant = 21;
    private static final int etatCourrierSortant = 20;

    public static final int etatOpRepayer = -1;
    public static final int etatFormationRealise = 12;

    public static final int etatDossierValider = 9;
    public static final int etatRenteRadier = 3;

    private static final int etatLivreDisponible = 11;
    private static final int etatLivreIndisponible = 12;
    private static final int etatSupprimer = -11;
    private static final int etatCongeDemandeApprouve = 9;
    private static final int etatMissionTermine = 21;
    private static final int etatMissionApprouve = 9;

    public static final int etatDAORejete = -1;
    public static final int etatDAOAccorde = 21;

    public static int getEtatDAORejete() {
        return etatDAORejete;
    }

    public static int getEtatDAOAccorde() {
        return etatDAOAccorde;
    }

    public static int getEtatCourrierRetourner() {
        return etatCourrierRetourner;
    }

    public static int getEtatTVACloturee() {
        return etatTVACloturee;
    }

    public static int getEtatCongeDemandeApprouve() {
        return etatCongeDemandeApprouve;
    }

    public static int getEtatMissionApprouve() {
        return etatMissionApprouve;
    }

    public static int getEtatDossierValider() {
        return etatDossierValider;
    }

    public static int getEtatCourrierRecu() {
        return etatCourrierRecu;
    }

    public static int getEtatOpRepayer() {
        return etatOpRepayer;
    }

    public static int getEtatEvalue() {
        return etatEvalue;
    }

    public static int getEtatGrandLivreDejaRepporte() {
        return etatGrandLivreDejaRepporte;
    }

    public static int getEtatJournalFermer() {
        return etatJournalFermer;
    }

    public static int getEtatCmViseParDg() {
        return etatCmViseParDg;
    }

    public static int getEtatCmViseParDc() {
        return etatCmViseParDc;
    }

    public static int getEtatCmEnregistre() {
        return etatCmEnregistre;
    }

    public static int getEtatReleveConstater() {
        return etatReleveConstater;
    }
    public static final int etatDemandeRechargeCarteValiderSup = 110;

    public static int getEtatImmoRemiseMagasin() {
        return etatImmoRemiseMagasin;
    }

    public static int getEtatDemandeLivre() {
        return etatDemandeLivre;
    }

    public static int getEtatDemandeAccepte() {
        return etatDemandeAccepte;
    }

    public static int getEtatDemandeLivraisonPrepare() {
        return etatDemandeLivraisonPrepare;
    }

    public static int getEtatDemandeLivraisonEnvoye() {
        return etatDemandeLivraisonEnvoye;
    }

    public static int getEtatDemandeLivraisonRecue() {
        return etatDemandeLivraisonRecue;
    }

    public static int getEtatDemandeEnvoye() {
        return etatDemandeEnvoye;
    }

    public static int getEtatDemandeRecue() {
        return etatDemandeRecue;
    }

    public static int getEtatDemandeVise() {
        return etatDemandeVise;
    }

    public static int getEtatTefInclusTitreValider() {
        return etatTefInclusTitreValider;
    }

    public static int getEtatTefInclusTitreRejeter() {
        return etatTefInclusTitreRejeter;
    }

    public static int getEtatOpInclusTitreRejeter() {
        return etatOpInclusTitreRejeter;
    }

    public static int getEtatOpInclusTitreValider() {
        return etatOpInclusTitreValider;
    }

    public static int getEtatOpInclusTitreCreer() {
        return etatOpInclusTitreCreer;
    }

    public static int getEtatOvInclusTitreValider() {
        return etatOvInclusTitreValider;
    }

    public static int getEtatOvInclusTitreRejeter() {
        return etatOvInclusTitreRejeter;
    }

    public static int getEtatOvInclusTitreCree() {
        return etatOvInclusTitreCree;
    }

    public static int getEtatPensSusp() {
        return etatPensSusp;
    }

    public static int getEtatImmoCondamne() {
        return etatImmoCondamne;
    }

    public static int getEtatImmoCede() {
        return etatImmoCede;
    }

    public static int getEtatEcritureContre() {
        return etatEcritureContre;
    }

    public static int getEtatDossierRecue() {
        return etatDossierRecue;
    }

    public static int getEtatPaye() {
        return etatPayer;
    }

    public static int getEtatTalonDNOk() {
        return etatTalonDNOk;
    }

    private static final int etatImmoAttribuer = 17;

    public static int getEtatEcritureCessionGenerer() {
        return etatEcritureCessionGenerer;
    }

    public static int getEtatDemandePriseEnChargeDejaPrise() {
        return etatDemandePriseEnChargeDejaPrise;
    }

    public static int getEtatDemandeConsultationDejaConsulte() {
        return etatDemandeConsultationDejaConsulte;
    }

    public static int getEtatImmoAttribuer() {
        return etatImmoAttribuer;
    }

    public static int getEtatDnok() {
        return etatDnok;
    }

    public static String getSignificationSituationDroit(int situation) {
        if (situation == 28 || situation == 38 || situation == 48) {
            return "Suspension automatique";
        }
        if (situation == 11) {
            return "Situation ok";
        }
        if (situation == 8) {
            return "Suspendue";
        }
        if (situation == 9) {
            return "Bloqu�e";
        }
        if (situation == 18) {
            return "Rappel";
        } else {
            return "";
        }
    }

    public static int getEtatEcritureGenerer() {
        return etatEcritureGenerer;
    }

    public static int getEtatCreer() {
        return etatCreer;
    }

    public static int getEtatRejeter() {
        return etatRejeter;
    }

    public static int getEtatObjetRejeter() {
        return etatObjetRejeter;
    }

    public static int getEtatEcritureValider() {
        return etatEcritureValider;
    }

    public static int getEtatSituationdroitOK() {
        return etatSituationdroitOK;
    }

    public static int getEtatSituationdroitSuspendue() {
        return etatSituationdroitSuspendue;
    }

    public static int getEtatSituationdroitBloquer() {
        return etatSituationdroitBloquer;
    }

    public static int getEtatSituationdroitRappel() {
        return etatSituationdroitRappel;
    }

    public static int getEtatTefEnCasOvCloturer() {
        return etatTefEnCasOvCloturer;
    }

    public static int getEtatTefEnCasOvValider() {
        return etatTefEnCasOvValider;
    }

    public static int getEtatTefRejeter() {
        return etatTefRejeter;
    }

    public static int getEtatObjetValider() {
        return etatObjetValider;
    }

    public static int getEtatTefEnCasOvRejeter() {
        return etatTefEnCasOvRejeter;
    }

    public static int getEtatAnnuler() {
        return etatAnnuler;
    }

    public static int getEtatTefEnCasOpValider() {
        return etatTefEnCasOpValider;
    }

    public static int getEtatValiderSupOp() {
        return etatValiderSupOp;
    }

    public static int getEtatCloture() {
        return etatCloture;
    }

    public static int getEtatTefCloture() {
        return etatTefCloture;
    }

    public static int getEtatTefEnCasOpRejeter() {
        return etatTefEnCasOpRejeter;
    }

    public static int getEtatOpInclusOvCree() {
        return etatOpInclusOvCree;
    }

    public static int getEtatOpInclusOvCloture() {
        return etatOpInclusOvCloture;
    }

    public static int getEtatOvCloture() {
        return etatOvCloture;
    }

    public static int getEtatOpInclusOvRejeter() {
        return etatOpInclusOvRejeter;
    }
    private static final int etatRejetSupOv = 10;

    public static int getEtatRejetSupOv() {
        return etatRejetSupOv;
    }

    public static int getEtatOpInclusOvValide() {
        return etatOpInclusOvValide;
    }

    public static int getEtatValiderSupOv() {
        return etatValiderSupOv;
    }

    public static int getEtatValiderSupTef() {
        return etatValiderSupTef;
    }

    public static int getEtatRejetSupOp() {
        return etatRejetSupOp;
    }

    public static int getEtatValider() {
        return etatValider;
    }

    /**
     * @return the etatSituationdroitSuspensionAuto
     */
    public static int getEtatSituationdroitSuspensionAutoPMD() {
        return etatSituationdroitSuspensionAutoPMD;
    }

    public static int getEtatFinPlacement() {
        return etatFinPlacement;
    }

    public static int getEtatTefFictif() {
        return etatTefFictif;
    }

    public static String etatToChaine(String valeur) {
        int val = Utilitaire.stringToInt(valeur);
        if (val == ConstanteEtatPaie.getEtatAnnuler()) {
            return "<b style='color:orange'>ANNUL&Eacute;(E)</b>";
        }
        if (val == ConstanteEtatPaie.getEtatCloture()) {
            return "<b style='color:blue'>CLOTUR&Eacute;(E)</b>";
        }
        if (val >= ConstanteEtatPaie.getEtatValider()) {
            return "<b style='color:green'>VIS&Eacute;(E)</b>";
        }

        if (val == ConstanteEtatPaie.getEtatRejeter()) {
            return "<b style='color:red'>REJET&Eacute;(E)</b>";
        }
        if (val == ConstanteEtatPaie.getEtatCreer()) {
            return "<b style='color:lightskyblue'>CR&Eacute;&Eacute;(E)</b>";
        }
        if (val == ConstanteEtatPaie.getEtatDesactiver()) {
            return "<b style='color:red'>D&Eacute;SACTIV&Eacute;(E)</b>";
        }

        //ecriture
        if (val == ConstanteEtatPaie.getEtatEcritureGenerer()) {
            return "<b>ECRITURE ACQUISITION GENER&Eacute;(E)</b>";
        }
        if (val == ConstanteEtatPaie.getEtatEcritureCessionGenerer()) {
            return "<b>ECRITURE CESSION GENER&Eacute;(E)</b>";
        }
        //cms
        if (val == ConstanteEtatPaie.getEtatDemandeConsultationDejaConsulte()) {
            return "<b>CONSULTATION GENER&Eacute;E POUR CETTE DEMANDE</b>";
        }

        if (val == ConstanteEtatPaie.getEtatFinPlacement()) {
            return "<b>Cl&ocirc;tur&eacute;</b>";
        }
        if (val == ConstanteEtatPaie.getEtatMalade()) {
            return "<b style='color:yellow'>Malade</b>";
        }
        if (val == ConstanteEtatPaie.getEtatPositif()) {
            return "<b style='color:red'>Positif</b>";
        }
        if (val == ConstanteEtatPaie.getEtatGueri()) {
            return "<b style='color:blue'>R&eacute;tabli</b>";
        }

        if (val == ConstanteEtatPaie.getEtatretourner()) {
            return "<b style='color:blue'>Retourn�/Rendu</b>";
        }
        if (val == getEtatTalonDNOk()) {
            return "<b style='color:blue'>TALON DN OK</b>";
        }
        return "<b>AUTRE</b>";
    }

    /**
     * @return the etatSituationdroitSuspensionAutoBAF
     */
    public static int getEtatSituationdroitSuspensionAutoBAF() {
        return etatSituationdroitSuspensionAutoBAF;
    }

    /**
     * @return the etatSituationdroitSuspensionAutoCIE
     */
    public static int getEtatSituationdroitSuspensionAutoCIE() {
        return etatSituationdroitSuspensionAutoCIE;
    }

    /**
     * @return the etatEnAttente
     */
    public static int getEtatProforma() {
        return etatProforma;
    }

    /**
     * @return the etatVehiculeDisponible
     */
    public static int getEtatVehiculeDisponible() {
        return etatVehiculeDisponible;
    }

    /**
     * @return the etatVehiculeMaintenance
     */
    public static int getEtatVehiculeMaintenance() {
        return etatVehiculeMaintenance;
    }

    /**
     * @return the etatVehiculeEnDeplacement
     */
    public static int getEtatVehiculeEnDeplacement() {
        return etatVehiculeEnDeplacement;
    }

    /**
     * @return the etatTalonVentillationValider
     */
    public static int getEtatTalonVentillationValider() {
        return etatTalonVentillationValider;
    }

    public static int getConstanteEtatFinaliser() {
        return constanteEtatFinaliser;
    }

    public static int getEtatBCTefCreer() {
        return etatBCTefCreer;
    }

    public static int getEtatPlanningEntretienNonRealise() {
        return etatPlanningEntretienNonRealise;
    }

    public static int getEtatPlanningEntretienRealise() {
        return etatPlanningEntretienRealise;
    }

    public static int getEtatretourner() {
        return etatretourner;
    }

    /**
     * @return the etatRadie
     */
    public static int getEtatDossierRetourne() {
        return etatDossierRetourne;
    }

    /**
     * @return the etatArchiveDetruiser
     */
    public static int getEtatArchiveDetruiser() {
        return etatArchiveDetruiser;
    }

    /**
     * @return the Etatdispatcher
     */
    public static int getEtatdispatcher() {
        return Etatdispatcher;
    }

    /**
     * @return the etatNonRecue
     */
    public static int getEtatNonRecue() {
        return etatNonRecue;
    }

    public static int getEtatLivreDisponible() {
        return etatLivreDisponible;
    }

    public static int getEtatLivreIndisponible() {
        return etatLivreIndisponible;
    }

    public static int getEtatSupprimer() {
        return etatSupprimer;
    }

    public static int getEtatPretRetour() {
        return etatPretretour; //To change body of generated methods, choose Tools | Templates.
    }

    /**
     * @return the etatRDeclarationConstater
     */
    public static int getEtatRDeclarationConstater() {
        return etatRDeclarationConstater;
    }

    public static int getEtatMissionTermine() {
        return etatMissionTermine;
    }

    /**
     * @return the etatCourrierEntrant
     */
    public static int getEtatCourrierEntrant() {
        return etatCourrierEntrant;
    }

    /**
     * @return the etatCourrierEntrant
     */
    public static int getEtatCourrierSortant() {
        return etatCourrierSortant;
    }

    /**
     * @return the etatORPaye
     */
    public static int getEtatORPaye() {
        return etatORPaye;
    }

    public static int getEtatNotificationLue() {
        return etatNotificationLue;
    }

    public static int getEtatNotificationNonLue() {
        return etatNotificationNonLue;
    }

    public static int getEtatPayer() {
        return etatPayer;
    }
    public static final int etatPlanifie = 17;

    public static int getEtatPlanifie() {
        return etatPlanifie;
    }

    public static int getEtatvaliderparmanager() {
        return etatValiderParManager;
    }

    public static int getEtatrefuserparmanager() {
        return etatRefuserParManager;
    }
}
