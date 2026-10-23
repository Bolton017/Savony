
<%@page import="paie.employe.EmployeComplet"%>
<%@page import="societe.Societe"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageInsert"%>
<%@ page import="paie.categorie.CategoriePaie" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="entretien.*" %>
<%
    try {
        String titre = "Saisie des informations du personnel";
        if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update"))
        {
            titre = "Modification des informations du personnel";
        }
        String idEntretient=request.getParameter("idEntretient");

        String autreparsley = "data-parsley-range='[8, 40]' required";
        String classe = "paie.employe.EmployeComplet";
        String apres = "paie/employe/personnel-fiche-portrait.jsp";

        EmployeComplet ec = new EmployeComplet();
        ec.setNomTable("EMPLOYE_COMPLET");
        if(idEntretient!=null && !idEntretient.isEmpty()){
            Entretient entr=new Entretient();
            entr.setId(idEntretient);
            ec = entr.genererPersonnel(null);
        }
        PageInsert pi = new PageInsert(ec, request, (user.UserEJB) session.getValue("u"));
        String[] ordre = {

                "idSociete",

                "matricule",
                "idCivilite",
                "nom",
                "prenom",
                "nomDusage",
                "sexe",
                "date_naissance",
                "lieu_naissance_commune",
                "nationalite",
                "situation_matrimonial",
                "acte_naissance",
                "nbenfant",
                "cheminImage",
                "cturgence_nom_prenom",
                "cturgence_telephone1",

                "numero_cin",
                "date_cin",
                "date_dupl_cin",
                "lieu_delivrance_cin",
                "numeroSecuriteSociale",
                "numeroCarteSejour",
                "dateExpiration",

                "adresse",
                "adresse2",
                "commune",
                "direction",
                "code_postal",
                "distance",
                "pays",
                "telephone",
                "mail",


                "typeContrat",
                "referenceContrat",
                "debutcontrat",
                "fincontrat",
                "dateDebutPeriodeEssai",
                "dateFinPeriodeEssai",
                "dureePeriodeDessai",
                "dateembauche",
                "dateEntreeProfession",
                "dateEntreeEtablissement",

                "idDepartement",
                "service",
                "unite",
                "idBu",
                "idfonction",
                "idHierarchie",
                "idcategorie_paie",
                "idqualification",
                "idSection",
                "niveau",

                "typeCalcul",
                "salaireBase",
                "typeHoraire",
                "heurehebdomadaire",
                "modaliteTravail",
                "heuremensuel",
                "estRattacheCnaps",
                "numero_cnaps",
                "estRattacheOstie",
                "numero_ostie",
                "idBanque",
                "idAgence",
                "code_agence_banque",
                "banque_numero_compte",
                "banque_compte_cle",
                "pere",
                "mere",
        };
        pi.getFormu().setOrdre(ordre);
        for (String champ : ordre) {
            String val = request.getParameter(champ);
            if (val != null) {
                pi.getFormu().getChamp(champ).setDefaut(val);
            }
        }
        String idSoc = request.getParameter("idSociete");
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("nom").setLibelle("Nom (*)");
        pi.getFormu().getChamp("prenom").setLibelle("Pr&eacute;noms (*)");
        Liste[] liste = new Liste[23];
        TypeObjet s = new TypeObjet();
        s.setNomTable("sexe");
        liste[0] = new Liste("sexe",s,"val","id");
        TypeObjet sm = new TypeObjet();
        sm.setNomTable("situation_matrimoniale");
        liste[1] = new Liste("situation_matrimonial",sm,"val","id");
        TypeObjet t = new TypeObjet();
        t.setNomTable("type_contrat");
        liste[2] = new Liste("typeContrat",t,"val","id");
        //liste[3] = new Liste("personnel_etat");
        //liste[3].makeListeOuiNon();

        TypeObjet regionObjet = new TypeObjet();
        regionObjet.setNomTable("log_direction");

        liste[3] = new Liste("direction", regionObjet, "val", "id");
        liste[3].setDefaut("DIR00001");
        CategoriePaie objet = new CategoriePaie();
        objet.setNomTable("categorie_paie");
        liste[4] = new Liste("idcategorie_paie",objet, "val", "id");

        TypeObjet qualPaie = new TypeObjet();
        qualPaie.setNomTable("QUALIFICATION_PAIE");
        liste[5] = new Liste("idqualification",qualPaie, "val", "id");

        TypeObjet modePaiementObjet = new TypeObjet();
        modePaiementObjet.setNomTable("modepaiement");
        liste[6] = new Liste("mode_paiement", modePaiementObjet, "val", "id");

//        TypeObjet formationdiplome = new TypeObjet();
//        formationdiplome.setNomTable("formation_diplome");
//        liste[7] = new Liste("formation", formationdiplome, "val", "id");

        TypeObjet departement = new TypeObjet();
        departement.setNomTable("DEPARTEMENT");
        String aWhereBusinessUnite = "";
        if (idSoc != null)
        {
            aWhereBusinessUnite = " AND IDSOCIETE = '" + idSoc + "'";
        }
        liste[7] = new Liste("idDepartement", departement, "val", "id");

        TypeObjet civ = new TypeObjet();
        civ.setNomTable("CIVILITE");
        liste[8] = new Liste("idCivilite", civ, "val", "id");

        TypeObjet bnq = new TypeObjet();
        bnq.setNomTable("Banque");
        liste[9] = new Liste("idBanque", bnq, "val", "id");

        TypeObjet unite = new TypeObjet();
        unite.setNomTable("LOG_UNITE");
        liste[10] = new Liste("unite", unite, "val", "id");


        TypeObjet typecalcul = new TypeObjet();
        typecalcul.setNomTable("TYPECALCUL");
        liste[11] = new Liste("typeCalcul", typecalcul, "val", "id");

        TypeObjet typeHoraire = new TypeObjet();
        typeHoraire.setNomTable("typeHoraire");
        liste[12] = new Liste("typeHoraire", typeHoraire, "val", "id");

        TypeObjet modaliteTravail = new TypeObjet();
        modaliteTravail.setNomTable("modaliteTravail");
        liste[13] = new Liste("modaliteTravail", modaliteTravail, "val", "id");

        Societe idSociete = new Societe();
        liste[14] = new Liste("idSociete", idSociete, "nom", "idSpat");

        liste[15] = new Liste("estRattacheCnaps");
        liste[15].makeListeOuiNon();

        liste[16] = new Liste("estRattacheOstie");
        liste[16].makeListeOuiNon();

        TypeObjet cantine = new TypeObjet();
        cantine.setNomTable("STATUTCANTINE");
        liste[17] = new Liste("cantine",cantine,"val","id");

        liste[18] = new Liste("transport");
        String[] affiche2 = new String[]{"Transport assur&eacute;", "Indemnit&eacute; de transport"};
        String[] valeur2 = new String[]{"1", "0"};
        liste[18].setValeurBrute(affiche2);
        liste[18].setColValeurBrute(valeur2);

        TypeObjet idSection = new TypeObjet();
        idSection.setNomTable("section");
        liste[19] = new Liste("idSection", idSection, "val", "id");

        TypeObjet idBu = new TypeObjet();
        idBu.setNomTable("BUSINESS_UNITE");
        liste[20] = new Liste("idBu", idBu, "val", "id", aWhereBusinessUnite);

        String[] valDuree = {"1", "3", "4"};
        String[] affDuree = {"1", "3", "4"};
        liste[21] = new Liste("dureePeriodeDessai", valDuree, affDuree);

        liste[22] = new Liste("estHandicape");
        liste[22].makeListeOuiNon();

        pi.getFormu().changerEnChamp(liste);




        if (idSoc != null)
        {
            pi.getFormu().getChamp("idSociete").setDefaut(idSoc);
        }
        if (idEntretient != null)
        {
            pi.getFormu().setDefaut(ec);
            pi.getFormu().getChamp("date_naissance").setDefaut(Utilitaire.formatterDaty(ec.getDate_naissance()));
        }

        pi.getFormu().getChamp("service").setPageAppelComplete("paie.log.LogService","id","log_service_libelle");
        pi.getFormu().getChamp("idfonction").setPageAppelComplete("paie.edition.PaieFonction","id","PAIE_FONCTIONLIBELLE");
        pi.getFormu().getChamp("idcategorie_paie").setPageAppelComplete("paie.categorie.CategoriePaie","id","CATEGORIE_PAIE_LIB");

        pi.getFormu().getChamp("id_pers").setVisible(false);
        pi.getFormu().getChamp("lieu_naissance_commune").setLibelle("Lieu de naissance (*)");
        pi.getFormu().getChamp("numero_cin").setLibelle("Num&eacute;ro CIN ou Passeport(*)");
        pi.getFormu().getChamp("date_dupl_cin").setLibelle("Date De Duplicata CIN");
        pi.getFormu().getChamp("idCivilite").setLibelle("Civilit&eacute");
        pi.getFormu().getChamp("mere").setLibelle("Nom de la M&egrave;re");
        pi.getFormu().getChamp("pere").setLibelle("Nom du P&egrave;re");
        pi.getFormu().getChamp("idAgence").setLibelle("Agence");
        pi.getFormu().getChamp("idAgence").setPageAppelComplete("paie.employe.BanqueAgenceLib","id","BanqueAgenceLib");

        pi.getFormu().getChamp("adresse").setLibelle("Adresse (*)");
        pi.getFormu().getChamp("nationalite").setLibelle("Nationalit&eacute;");
        pi.getFormu().getChamp("nationalite").setDefaut("Malagasy");
        pi.getFormu().getChamp("situation_matrimonial").setLibelle("Situation matrimoniale");
        pi.getFormu().getChamp("idcategorie").setVisible(false);
        pi.getFormu().getChamp("indicegrade").setVisible(false);
        pi.getFormu().getChamp("matricule_patron").setVisible(false);
        pi.getFormu().getChamp("initiale").setVisible(false);
        pi.getFormu().getChamp("date_naissance").setLibelle("Date de naissance (*)");
        pi.getFormu().getChamp("sexe").setLibelle("Genre");
        pi.getFormu().getChamp("date_cin").setLibelle("Date De D&eacute;livrance CIN (*)");
        pi.getFormu().getChamp("lieu_delivrance_cin").setLibelle("Lieu De D&eacute;livrance CIN (*)");
        pi.getFormu().getChamp("fokotany").setVisible(false);
        pi.getFormu().setNbColonne(2);
        pi.getFormu().getChamp("matricule").setLibelle("Matricule propre (*)");
        pi.getFormu().getChamp("matricule").setVisible(false);

        pi.getFormu().getChamp("direction").setLibelle("R&eacute;gion");
        pi.getFormu().getChamp("mode_paiement").setLibelle("Mode de paiement");
        pi.getFormu().getChamp("idfonction").setLibelle("Fonction (*)");
        pi.getFormu().getChamp("idBanque").setLibelle("Banque");

        pi.getFormu().getChamp("estRattacheCnaps").setLibelle("Est rattach&eacute; CNAPS");

        pi.getFormu().getChamp("banque_numero_compte").setLibelle("Num&eacute;ro compte");
        pi.getFormu().getChamp("permis_conduire").setVisible(false);
        pi.getFormu().getChamp("chemin_permis").setVisible(false);
        pi.getFormu().getChamp("cturgence_telephone1").setLibelle("T&eacute;l. Contact D'urgence");

        pi.getFormu().getChamp("echelon").setVisible(false);
        pi.getFormu().getChamp("cturgence_telephone3").setVisible(false);
        pi.getFormu().getChamp("datesaisie").setVisible(false);
        pi.getFormu().getChamp("vehiculee").setVisible(false);

        pi.getFormu().getChamp("droit_hs").setVisible(false);
        // pi.getFormu().getChamp("heurehebdomadaire").setVisible(false);
        pi.getFormu().getChamp("numero_cnaps").setLibelle("Num&eacute;ro CNAPS (*)");
        pi.getFormu().getChamp("typeContrat").setLibelle("Type De Contrat (*)");

        pi.getFormu().getChamp("indesirable").setLibelle("Dur&eacute;e si P&eacute;riode D'essaie Ou CDD (mois)");
        pi.getFormu().getChamp("indesirable").setVisible(false);
        pi.getFormu().getChamp("telephone").setLibelle("T&eacute;l&eacute;phone (*)");
        pi.getFormu().getChamp("idcategorie_paie").setLibelle("Status (*)");
        pi.getFormu().getChamp("discipline").setLibelle("Discipline");
        pi.getFormu().getChamp("anneeExperience").setLibelle("Ann&eacute;e d'exp&eacute;rience au poste");
        pi.getFormu().getChamp("debutcontrat").setLibelle("Date De D&eacute;but Du Contrat (*)");
        pi.getFormu().getChamp("debutcontrat").setVisible(false);

        pi.getFormu().getChamp("classee").setVisible(false);
        pi.getFormu().getChamp("statut").setVisible(false);
        //pi.getFormu().getChamp("code_agence_banque").setVisible(false);
        //pi.getFormu().getChamp("banque_compte_cle").setVisible(false);
        pi.getFormu().getChamp("cturgence_nom_prenom").setLibelle("Nom Du Contact D'urgence");
        pi.getFormu().getChamp("cturgence_telephone2").setVisible(false);
        //pi.getFormu().getChamp("adresse_ligne2").setLibelle("Commune");
        //pi.getFormu().getChamp("code_postal").setLibelle("Code postal");
        pi.getFormu().getChamp("service").setLibelle("Service");
        pi.getFormu().getChamp("region").setLibelle("R&eacute;gion");
        pi.getFormu().getChamp("region").setVisible(false);
        pi.getFormu().getChamp("formation").setLibelle("Formation/dipl&ocirc;me");
        pi.getFormu().getChamp("formation").setVisible(false);


        pi.getFormu().getChamp("cheminImage").setVisible(false);
        //pi.getFormu().getChamp("cheminImage").setLibelle("Nom de l'image");
//        pi.getFormu().getChamp("cheminImage").setType("file");

        pi.getFormu().getChamp("banque_code").setVisible(false);
        pi.getFormu().getChamp("date_dernierpromo").setVisible(false);
        //pi.getFormu().getChamp("heuremensuel").setVisible(false);
        pi.getFormu().getChamp("numero_ostie").setLibelle("Num&eacute;ro OSTIE/OMSIE");
        pi.getFormu().getChamp("estRattacheOstie").setLibelle("Est rattach&eacute; OSTIE");
        pi.getFormu().getChamp("estRattacheOstie").setLibelle("Est rattach&eacute; OSTIE");
        pi.getFormu().getChamp("cantine").setLibelle("Cantine");
        pi.getFormu().getChamp("transport").setLibelle("Transport");
        pi.getFormu().getChamp("nbenfant").setLibelle("Enfant(S) &Agrave; Charge");
        pi.getFormu().getChamp("duree").setVisible(false);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("ctg").setVisible(false);
        pi.getFormu().getChamp("idconjoint").setVisible(false);
        pi.getFormu().getChamp("idqualification").setLibelle("Classification");
        pi.getFormu().getChamp("personnel_etat").setVisible(false);
        pi.getFormu().getChamp("fincontrat").setLibelle("Date De Fin Du Contrat");
        pi.getFormu().getChamp("acte_naissance").setLibelle("Nom Du Ou De La Conjoint(e) L&eacute;gale");
        pi.getFormu().getChamp("dateembauche").setLibelle("Date D'embauche (*)");
        pi.getFormu().getChamp("heurejournalier").setVisible(false);
        pi.getFormu().getChamp("indice_fonctionnel").setVisible(false);
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("temporaire").setVisible(false);
        pi.getFormu().getChamp("mail").setLibelle("Adresse e-mail");
        pi.getFormu().getChamp("idDepartement").setLibelle("Direction (*)");
        pi.getFormu().getChamp("code_postal").setLibelle("Code postal");

        pi.getFormu().getChamp("idfonction").setPageAppelInsert("paie/fonction/paiefonction-saisie.jsp", "idfonction;idfonctionlibelle", "id;val");
        pi.getFormu().getChamp("service").setPageAppelInsert("paie/service/service-saisie.jsp", "service;servicelibelle", "id;libelle");
        pi.getFormu().getChamp("idAgence").setPageAppelInsert("paie/employe/banqueagence-saisie.jsp", "idAgence;idAgencelibelle", "id;nom");

        pi.getFormu().getChamp("idCiviliteLib").setVisible(false);
        pi.getFormu().getChamp("idBanqueLib").setVisible(false);
        pi.getFormu().getChamp("codeAgence").setVisible(false);
        pi.getFormu().getChamp("idAgenceLib").setVisible(false);
        pi.getFormu().getChamp("code_postal").setVisible(false);

        pi.getFormu().getChamp("nomDusage").setLibelle("Nom d'usage");
        pi.getFormu().getChamp("nomDusage").setVisible(false);
        pi.getFormu().getChamp("numeroSecuriteSociale").setLibelle("Num&eacute;ro s&eacute;curit&eacute; sociale");
        pi.getFormu().getChamp("numeroSecuriteSociale").setVisible(false);
        pi.getFormu().getChamp("numeroCarteSejour").setLibelle("Num&eacute;ro carte s&eacute;jour");
        pi.getFormu().getChamp("numeroCarteSejour").setVisible(false);
        pi.getFormu().getChamp("dateExpiration").setLibelle("Date d'expiration");
        pi.getFormu().getChamp("adresse2").setLibelle("Compl&eacute;ment adresse");
        pi.getFormu().getChamp("adresse2").setVisible(false);
        pi.getFormu().getChamp("commune").setLibelle("Ville/Commune");
        pi.getFormu().getChamp("pays").setLibelle("Pays");
        pi.getFormu().getChamp("pays").setPageAppelComplete("bean.TypeObjet","id","PAYS");

        pi.getFormu().getChamp("referenceContrat").setLibelle("R&eacute;f&eacute;rence du contrat");
        pi.getFormu().getChamp("referenceContrat").setVisible(false);
        pi.getFormu().getChamp("dateDebutPeriodeEssai").setLibelle("Date d&eacute;but p&eacute;riode d'essai ");
        pi.getFormu().getChamp("dateFinPeriodeEssai").setLibelle("Date fin p&eacute;riode d'essai");
//        pi.getFormu().getChamp("dateFinPeriodeEssai").setVisible(false);
        pi.getFormu().getChamp("typeEntree").setLibelle("Type d'entr&eacute;e");
        pi.getFormu().getChamp("typeEntree").setVisible(false);
        pi.getFormu().getChamp("dateEntreeProfession").setLibelle("Date entr&eacute;e dans la profession");
        pi.getFormu().getChamp("dateEntreeProfession").setVisible(false);
        pi.getFormu().getChamp("dateEntreeEtablissement").setLibelle("Date entr&eacute;e dans l'&eacute;tablissement");
        pi.getFormu().getChamp("dateEntreeEtablissement").setVisible(false);
        pi.getFormu().getChamp("dureePeriodeDessai").setLibelle("Dur&eacute;e p&eacute;riode d'essai (mois)");
        //pi.getFormu().getChamp("dureePeriodeDessai").setVisible(false);
        pi.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
        pi.getFormu().getChamp("idHierarchie").setLibelle("Responsable hi&eacute;rarchique");
        pi.getFormu().getChamp("idHierarchie").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2");
        pi.getFormu().getChamp("indice").setLibelle("Indice");
        pi.getFormu().getChamp("indice").setVisible(false);
        pi.getFormu().getChamp("niveau").setLibelle("Niveau");
        pi.getFormu().getChamp("niveau").setVisible(false);
        pi.getFormu().getChamp("coefficient").setLibelle("Coefficient");
        pi.getFormu().getChamp("coefficient").setVisible(false);
        pi.getFormu().getChamp("dateDebutPoste").setLibelle("Date d&eacute;but poste ");
        pi.getFormu().getChamp("dateDebutPoste").setVisible(false);
        pi.getFormu().getChamp("dateFinPoste").setLibelle("Date fin poste");
        pi.getFormu().getChamp("dateFinPoste").setVisible(false);


        pi.getFormu().getChamp("typeCalcul").setLibelle("Type de paie");
        pi.getFormu().getChamp("salaireBase").setLibelle("Salaire de base ");
        pi.getFormu().getChamp("typeHoraire").setLibelle("Type d'horaire");
        pi.getFormu().getChamp("heurehebdomadaire").setLibelle("Heures hebdomadaires");
        pi.getFormu().getChamp("modaliteTravail").setLibelle("Temps de travail");
        pi.getFormu().getChamp("heuremensuel").setLibelle("Volume horaire mensuel");

        pi.getFormu().getChamp("idSociete").setLibelle("Soci&eacute;te");
        pi.getFormu().getChamp("idSociete").setAutre("onchange=\"idSocieteChanged(this)\"");
        pi.getFormu().getChamp("commune").setPageAppelComplete("paie.annexe.VilleLib","id","VILLELIB","codePostal","code_postal");
        pi.getFormu().getChamp("commune").setAc_affiche("nom");
        pi.getFormu().getChamp("commune").setPageAppelInsert("paie/annexe/ville-saisie.jsp", "commune;communelibelle", "id;nom");
        pi.getFormu().getChamp("idSection").setLibelle("Section");
        pi.getFormu().getChamp("idBu").setVisible(false);
        pi.getFormu().getChamp("code_agence_banque").setLibelle("Code guichet");
        pi.getFormu().getChamp("banque_compte_cle").setLibelle("Cl&eacute; Rib");
        pi.getFormu().getChamp("natureHandicap").setLibelle("Nature du handicap");
        pi.getFormu().getChamp("estHandicape").setLibelle("Est handicap&eacute;");
        pi.getFormu().getChamp("estHandicape").setAutre("onchange=\"toggleNatureHandicap()\"");


        LinkedHashMap<String, String[]> rubriques = new LinkedHashMap<String, String[]>();

        rubriques.put("Soci&eacute;te", new String[]{
                "idSociete"
        });

        rubriques.put("&Eacute;tat Civil", new String[]{
                "matricule",
                "sexe",
                "idCivilite",
                "nom",
                "prenom",
                "nomDusage",
                "date_naissance",
                "lieu_naissance_commune",
                "pere",
                "mere",
                "acte_naissance",
                "situation_matrimonial",
                "nbenfant",
                "nationalite",
                "cturgence_nom_prenom",
                "cturgence_telephone1",
                "cheminImage",
                "estHandicape",
                "natureHandicap"

        });

        rubriques.put("Immatriculation", new String[]{
                "numero_cin",
                "date_cin",
                "date_dupl_cin",
                "lieu_delivrance_cin",
                "numeroSecuriteSociale",
                "numeroCarteSejour",
                "dateExpiration",

        });

        rubriques.put("Adresse / Coordonn&eacute;es", new String[]{
                "adresse",
                "adresse2",
                "commune",
                "direction",
                "code_postal",
                "distance",
                "pays",
                "telephone",
                "mail"
        });

        rubriques.put("Contrat de travail", new String[]{
                "typeContrat",
                "referenceContrat",
                "debutcontrat",
                "fincontrat",
                "dateDebutPeriodeEssai",
                "dateFinPeriodeEssai",
                "dureePeriodeDessai",
                "dateembauche",
                "dateEntreeProfession",
                "dateEntreeEtablissement"
        });

        rubriques.put("Poste", new String[]{
                "idDepartement",
                "service",
                "unite",
                "idBu",
                "idfonction",
                "idHierarchie",
                "idcategorie_paie",
                "idqualification",
                "idSection",
                "niveau"
        });

        rubriques.put("Salaire et Horaire de travail", new String[]{
                "typeCalcul",
                "salaireBase",
                "typeHoraire",
                "heurehebdomadaire",
                "modaliteTravail",
                "heuremensuel"
        });



        // rubriques.put("Informations personnelles", new String[]{
//                "nom",
//                "prenom",
//                "sexe",
//                "date_naissance",
//                "lieu_naissance_commune",
//                "situation_matrimonial",
//                "acte_naissance",
//                "nbenfant"
//        });

//        rubriques.put("Informations d'identit&eacute; (CIN)", new String[]{
//                "numero_cin",
//                "date_cin",
//                "date_dupl_cin",
//                "lieu_delivrance_cin"
//        });
//
//        rubriques.put("Coordonnées & contact", new String[]{
//                "adresse",
//                "code_postal",
//                "telephone",
//                "mail",
//                "cturgence_nom_prenom",
//                "cturgence_telephone1"
//        });
//
//        rubriques.put("Situation professionnelle", new String[]{
//                "idfonction",
//                "idcategorie_paie",
//                "idqualification",
//                "discipline",
//                "anneeExperience",
//                "service",
//                "idDepartement",
//                "direction"
//        });
//
//        rubriques.put("Contrat & carri&egrave;re", new String[]{
//                "typeContrat",
//                "debutcontrat",
//                "fincontrat",
//                "dateembauche",
//                "indesirable"
//        });
//
        rubriques.put("Organismes sociaux", new String[]{
                "numero_cnaps",
                "numero_ostie",
                "estRattacheCnaps",
                "estRattacheOstie"
        });

        rubriques.put("Autres informations", new String[]{
                "mode_paiement",
                "idBanque",
                "idAgence",
                "code_agence_banque",
                "banque_numero_compte",
                "banque_compte_cle",
                "discipline",
                "anneeExperience",
                "cantine",
                "transport",
                "remarque"
        });

// Application au formulaire
        pi.getFormu().setRubrique(rubriques);



        //String[] colOrdre = {"nom", "prenom", "dateembauche", "date_naissance", "lieu_naissance_commune", "sexe", "telephone", "mail", "adresse", "numero_cin", "date_cin", "date_dupl_cin", "lieu_delivrance_cin", "situation_matrimonial","service", "idDepartement", "acte_naissance", "direction", "temporaire","indesirable", "debutcontrat", "fincontrat", "mode_paiement", "banque_numero_compte", "idfonction", "cturgence_nom_prenom", "cturgence_telephone1", "numero_cnaps", "numero_ostie", "nbenfant","idcategorie_paie","idqualification","matricule","discipline","anneeExperience","personnel_etat"};
        String[] colOrdre = {
                "idSociete",
                "matricule",
                "idCivilite",
                "nom",
                "prenom",
                "nomDusage",
                "sexe",
                "date_naissance",
                "lieu_naissance_commune",
                "nationalite",
                "situation_matrimonial",
                "acte_naissance",
                "pere",
                "mere",
                "nbenfant",
                "cheminImage",
                "cturgence_nom_prenom",
                "cturgence_telephone1",

                "numero_cin",
                "date_cin",
                "date_dupl_cin",
                "lieu_delivrance_cin",
                "numeroSecuriteSociale",
                "numeroCarteSejour",
                "dateExpiration",

                "adresse",
                "adresse2",
                "commune",
                "direction",
                "code_postal",
                "distance",
                "pays",
                "telephone",
                "mail",

                "typeContrat",
                "referenceContrat",
                "debutcontrat",
                "fincontrat",
                "dateDebutPeriodeEssai",
                "dureePeriodeDessai",
                "dateFinPeriodeEssai",
                "dateembauche",
                "dateEntreeProfession",
                "dateEntreeEtablissement",

                "idDepartement",
                "service",
                "unite",
                "idBu",
                "idfonction",
                "idHierarchie",
                "idcategorie_paie",
                "idqualification",
                "idSection",
                "niveau",

                "typeCalcul",
                "salaireBase",
                "typeHoraire",
                "heurehebdomadaire",
                "modaliteTravail",
                "heuremensuel",

                "estRattacheCnaps",
                "numero_cnaps",
                "estRattacheOstie",
                "numero_ostie",

                "cantine",
                "transport",

                "discipline",
                "anneeExperience",
                "mode_paiement",

                "idBanque",
                "idAgence",
                "code_agence_banque",
                "banque_numero_compte",
                "banque_compte_cle",

                "remarque"
        };
        pi.getFormu().setOrdre(colOrdre);
        pi.preparerDataFormu();




%>
<div class="content-wrapper">
    <h1><%= titre %></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="nn" id="nn" >
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="daty" type="hidden" id="daty" value="<%=Utilitaire.dateDuJour()%>">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classe%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=ec.getNomTable()%>">
    </form>
</div>

<script>

    var textFields = document.querySelectorAll('input[type="text"]');
    var index = 0;
    for (index = 0; index < textFields.length; ++index) {
        var textField = textFields[index];
        textField.setAttribute("oninput", "this.value = this.value.toUpperCase()");
    }
    function champMontant(){
        let qual = $('#idqualification').val();
        let catpaie = $('#idcategorie_paie').val();

        if(qual && qual != "" && catpaie && catpaie != "" ){
            console.log('tairo!');
            $.ajax({
                type:'GET',
                url:'/fer/MontantInfoPers?idqualification='+qual+'&idcategorie_paie='+catpaie,
                contentType: 'text/html',
                success:function(ma){
                    var data = ma;
                    console.log(data);
                    $('#montant_af').val(data);
                }
            });

        }else{
            console.log('mbola!');
        }
    }
    function idSocieteChanged(el){
        var idSociete = el.value;

        const url = new URL(window.location.href);
        url.searchParams.set("idSociete", idSociete);

        window.location.href = url.toString();
    }

    function toggleNatureHandicap() {
        // 1. Récupérer la valeur du select (1 = OUI, 0 = NON)
        var estHandicapeVal = $('#estHandicape').val();

        // 2. Cibler le champ nature du handicap
        var champNature = $('#natureHandicap');

        // 3. Cibler le conteneur global (souvent form-group avec ce type de design Bootstrap)
        var conteneurGlobal = champNature.closest('.form-group');

        // 4. Cibler explicitement le label (au cas où le conteneur global n'est pas "form-group")
        var label = $('label[for="Nature du handicap"], label:contains("Nature du handicap")');

        if (estHandicapeVal === '1') {
            // Si OUI, on affiche tout
            if (conteneurGlobal.length > 0) {
                conteneurGlobal.show();
            } else {
                champNature.parent().show(); // Affiche la div de l'input
                label.show(); // Affiche le label
            }
        } else {
            // Si NON, on cache tout et on vide la valeur
            if (conteneurGlobal.length > 0) {
                conteneurGlobal.hide();
            } else {
                champNature.parent().hide(); // Cache la div de l'input
                label.hide(); // Cache le label
            }
            champNature.val(''); // Réinitialiser le champ caché
        }
    }

    window.addEventListener("load", function () {
        var el = document.getElementById("idSociete");
        if (!el) return;

        const url = new URL(window.location.href);
        const param = url.searchParams.get("idSociete");

        // first load only (no param yet)
        if (!param && el.value) {
            idSocieteChanged(el);
        }

        toggleNatureHandicap();
    });
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {

        const typeContrat = document.getElementById("typeContrat");
        const finContrat = document.getElementById("fincontrat");

        if (!typeContrat || !finContrat) return;

        const finContratDiv = finContrat.closest(".form-input");

        function checkContrat() {
            const value = typeContrat.value;

            if (value === "TYC00001") { //rehefa CDI de cache ny colonne date fin de contrat
                if (finContratDiv) finContratDiv.style.display = "none";
                finContrat.value = "";
            } else {
                if (finContratDiv) finContratDiv.style.display = "block";
            }
        }

        checkContrat();

        typeContrat.addEventListener("change", checkContrat);
    });
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {

        const typePaie = document.querySelector("select[name='typeCalcul']");
        const salaireInput = document.querySelector("input[name='salaireBase']");

        if (!typePaie || !salaireInput) return;

        function updateLibelle() {

            const label = salaireInput.closest(".form-input")?.querySelector("label");

            if (!label) return;

            const value = typePaie.value;

            if (value === "TYPCALC002") {
                label.innerHTML = "Salaire de base";
            } else if(value === "TYPCALC005") {
                label.innerHTML = "Base horaire";
            } else {
                label.innerHTML = "Salaire de base"
            }
        }

        // init au chargement
        updateLibelle();

        // changement
        typePaie.addEventListener("change", updateLibelle);
    });
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {

        const dateDebut = document.querySelector("input[name='dateDebutPeriodeEssai']");
        const duree = document.querySelector("select[name='dureePeriodeDessai']");
        const dateFin = document.querySelector("input[name='dateFinPeriodeEssai']");

        if (!dateDebut || !duree || !dateFin) return;

        // ✅ Parse dd/MM/yyyy safely
        function parseFRDate(str) {
            if (!str) return null;

            const parts = str.split('/');
            if (parts.length !== 3) return null;

            const day = parseInt(parts[0], 10);
            const month = parseInt(parts[1], 10);
            const year = parseInt(parts[2], 10);

            const date = new Date(year, month - 1, day);

            return isNaN(date.getTime()) ? null : date;
        }

        function formatDateFR(date) {
            let jour = String(date.getDate()).padStart(2, '0');
            let mois = String(date.getMonth() + 1).padStart(2, '0');
            let annee = date.getFullYear();

            console.log("oooooo", `${jour}/${mois}/${annee}`);

            return `${jour}/${mois}/${annee}`;
        }
        function calculDateFin() {
            const debutVal = dateDebut.value;
            const dureeVal = duree.value;
            console.log(" date debut et dureee  et date farany ", debutVal, dureeVal);
            if (!debutVal || !dureeVal) return;

            let date = parseFRDate(debutVal);
            if (!date) return;

            date.setMonth(date.getMonth() + parseInt(dureeVal));

            console.log(" dateeeeee ", date);

            dateFin.value = formatDateFR(date);
        }

        duree.addEventListener("change", calculDateFin);
        duree.addEventListener("input", calculDateFin);
        dateDebut.addEventListener("change", calculDateFin);
        dateDebut.addEventListener("input", calculDateFin);

        calculDateFin();

    });
</script>
<%
} catch (Exception e) {
    e.printStackTrace();
    String message = e.getMessage();
    if (message == null || message.trim().isEmpty()) {
        message = e.getClass().getName();
    }
    message = message.replace("\\", "\\\\").replace("'", "\\'").replace("\r", " ").replace("\n", " ");
%>
<script language="JavaScript">
    alert('<%=message%>');
    history.back();
</script>
<% }%>
