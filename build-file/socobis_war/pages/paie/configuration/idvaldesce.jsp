<%@page import="java.util.Map"%>
<%@page import="java.util.concurrent.ConcurrentHashMap"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%
    String cible = request.getParameter("ciblename");
    Map<String, String> titre = new ConcurrentHashMap<String, String>();
    titre.put("unite", "Unite");
    titre.put("as_point", "Point");
    titre.put("qualification_paie", "Qualification paie");
    titre.put("type_contrat", "Type de contrat");
    titre.put("nature_or", "Nature OR");
    titre.put("composante", "Composante");
    titre.put("type_absence", "Type absence");
    titre.put("antenne", "Antenne");
    titre.put("centre", "Centre");
    titre.put("configuration", "Ann&eacute;e");
    titre.put("secteur", "Secteur");
    titre.put("type_groupement", "Type groupement");
    titre.put("wilaya", "Wilaya");
    titre.put("statut_juridique", "Statut juridique");
    titre.put("type_ouvrage", "Type ouvrage");
    titre.put("nature_ouvrage", "Nature ouvrage");
    titre.put("groupe_code", "Groupe");
    titre.put("BUDGET_CATEGORIE_REJET_OP", "Cat&eacute;gorie rejet OP");
    titre.put("BUDGET_CATEGORIE_REJET_OV", "Cat&eacute;gorie rejet OV");
    titre.put("TRESO_CATEGORIE_REJET_TITRE", "Cat&eacute;gorie rejet titre");
    titre.put("COURIER_PRESTATAIRE", "Courier du prestataire");
    titre.put("cooperative", "Cooperative");
    titre.put("zones", "Zone");
    titre.put("ligne", "Ligne");
    titre.put("energie", "Energie");
    titre.put("type_vehicule", "Type Vehicule");
    titre.put("marque_vehicule", "Marque Vehicule");
    titre.put("genre_vehicule", "Genre Vehicule");
    titre.put("province", "Ville");
    titre.put("direction", "Direction");
    titre.put("type_demande_zone", "Type demande Zone");
    titre.put("soustype_demande_licence", "Sous Type Demande Licence");
    titre.put("type_demande_licence", "Type Demande Licence");
    titre.put("pieces_type_demande", "Piece Type Demande");
    titre.put("motif_conge", "Motif cong&eacute;");
    titre.put("log_direction", "Lieu d'affectation");
    titre.put("region", "R&eacute;gion");
    titre.put("formation_diplome", "Formation Diplome");
    titre.put("poste", "Poste");
    titre.put("modepaiement", "Mode de paiement");
    titre.put("paie_groupefonction", "Fonction groupe");
    titre.put("categorieingredient", "Famille");
    titre.put("categorieRessource" , "Ressource");
    titre.put("typeFinancement" , "Type de financement");
    titre.put("compta_journal" , "Journal");
    titre.put("compta_type_compte" , "Type compte");
    titre.put("compta_classe_compte" , "Classe compte");
    titre.put("config_immo" , "Configuration immo");
    
    titre.put("type_location" , "Type location");
    titre.put("fr_type_maintenance" , "Type maintenance");
    titre.put("fr_type_ravitaillement" , "Type ravitaillement");
    titre.put("fr_type_vehicule" , "Type vehicule");
    titre.put("compta_convention_programme","Plan Convention Programme");
    titre.put("compta_plan_budgetaire","Plan Budg&eacute;taire");
    titre.put("compta_plan_analytique","Axe Routier");

    titre.put("assureur","Assureur");
    
    
    TypeObjet act = new TypeObjet();
    
    act.setNomTable(cible);
    
    
    
   // act.setNomProcedureSequence("seq"+cible);
    PageInsert pi = new PageInsert(act, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
    
    String val = "Libell&eacute;";
    String desce = "Description";
    
    
    if(request.getParameter("value") != null && request.getParameter("value").compareToIgnoreCase("") != 0)val = request.getParameter("value");
    if(request.getParameter("description") != null && request.getParameter("description").compareToIgnoreCase("") != 0)desce = request.getParameter("description");
    
    
//    if(cible.equalsIgnoreCase("modepaiement")){
//        affichage.Champ[] liste = new affichage.Champ[1];
//        TypeObjet t = new TypeObjet();
//        t.setNomTable("modepaiement");
//        liste[0] = new Liste("desce", t, "val", "id");
//        pi.getFormu().changerEnChamp(liste);
//    }
    if(cible.equalsIgnoreCase("cooperative")){
        affichage.Champ[] liste = new affichage.Champ[1];
        TypeObjet t = new TypeObjet();
        t.setNomTable("zones");
        liste[0] = new Liste("desce", t, "val", "id");
        pi.getFormu().changerEnChamp(liste);
    }
    if(cible.equalsIgnoreCase("ligne")){
        affichage.Champ[] liste = new affichage.Champ[1];
        TypeObjet t = new TypeObjet();
        t.setNomTable("cooperative");
        liste[0] = new Liste("desce", t, "val", "id");
        pi.getFormu().changerEnChamp(liste);
    }
    
    if(cible.equalsIgnoreCase("province")){
        affichage.Champ[] liste = new affichage.Champ[1];
        TypeObjet t = new TypeObjet();
        t.setNomTable("type_province");
        liste[0] = new Liste("desce", t, "val", "id");
        pi.getFormu().changerEnChamp(liste);
    }
    
    if(cible.equalsIgnoreCase("compta_convention_programme") || cible.equalsIgnoreCase("compta_plan_budgetaire")){
        val = "Code";
        desce = "Libell&eacute;";
    }
    
    pi.getFormu().getChamp("val").setLibelle(val);
    pi.getFormu().getChamp("desce").setLibelle(desce);
    
    pi.getFormu().getChamp("desce").setType("textarea");
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%=titre.get(cible)%></h1>
    </section>
    <section class="content">

        <form action="<%=pi.getLien()%>?but=paie/configuration/apresIdvaldesce.jsp&ciblename=<%out.print(cible);%>&value=<%=val%>&description=<%=desce%>" method="post" name="configuration" id="idvaldesce">
            <div class="col-md-12 mb-5 nopadding">
                <%
                    pi.getFormu().makeHtmlInsertTabIndex();
                    out.println(pi.getFormu().getHtmlInsert());
                %>
            </div>

            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="paie/configuration/idvaldesce.jsp&ciblename=<%out.print(cible);%>&value=<%=val%>&description=<%=desce%>">
            <input name="classe" type="hidden" id="classe" value="bean.TypeObjet">
            <input name="nomtable" type="hidden" id="nomtable" value="<%out.print(cible);%>">
        </form>
        <%
            TypeObjet e = new TypeObjet();
            e = act;

            e.setNomTable(cible);
            if(cible.equalsIgnoreCase("cooperative")){
                e.setNomTable("cooperative_libelle_2");
            }
            if(cible.equalsIgnoreCase("ligne")){
                e.setNomTable("ligne_libelle");
            }
            if(cible.compareTo("province")==0){
                e.setNomTable("province_lib");
            }

            String listeCrt[] = {"id", "val", "desce"};
            String listeInt[] = null;
            String libEntete[] = {"id", "val", "desce"};
            PageRecherche pr = new PageRecherche(e, request, listeCrt, listeInt, 3, libEntete, 3);
            pr.setUtilisateur((user.UserEJB) session.getValue("u"));
            pr.setLien((String) session.getValue("lien"));
            pr.setApres("paie/configuration/idvaldesce.jsp&ciblename=" + cible);

            String[] colSomme = null;
            pr.creerObjetPage(libEntete, colSomme);
        %>
        <form action="<%=pr.getLien()%>?but=paie/configuration/idvaldesce.jsp&ciblename=<%out.println(cible);%>&value=<%=val%>&description=<%=desce%>"
              method="post" name="configuration" id="idvaldesce">
            <%
                pr.getFormu().getChamp("id").setLibelle("Identifiant");
                pr.getFormu().getChamp("val").setLibelle(val);
                pr.getFormu().getChamp("desce").setLibelle(desce);
                out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>

        <%
            String lienTableau[] = {pr.getLien() + "?but=paie/configuration/modif_idvaldesce.jsp&ciblename=" + cible + "&value=" + val + "&description"+desce};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <%
            String libEnteteAffiche[] = {"Identifiant", val, desce};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>