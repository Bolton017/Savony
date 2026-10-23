<%-- 
    Document   : paiepersonnelelementpaie-liste
    Created on : 21 d�c. 2020, 16:26:17
    Author     : Lenovo
--%>

<%@page import="paie.employe.EmployeContratTravail"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageRecherche"%>

<%  
    try{
    EmployeContratTravail dr = new EmployeContratTravail();
    String nomTable = "paie_info_pers_histo_contrat";

    if (request.getParameter("table") != null && request.getParameter("table").compareToIgnoreCase("") != 0) {
            nomTable = request.getParameter("table");
    }
    dr.setNomTable(nomTable);
     
    String listeCrt[] = {"id","matricule","nom","prenom","categorie_paielib","categorie_qualificationlib","date_debut","date_fin","montant"};
    String listeInt[] = {"date_debut","date_fin","montant"};
    String libEntete[] = {"id","matricule","nom","prenom","categorie_paielib","categorie_qualificationlib","montant","date_debut","date_fin","avenant"};
    
    PageRecherche pr = new PageRecherche(dr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        
    Liste[] liste = new Liste[1];
    TypeObjet m0 = new TypeObjet();
    m0.setNomTable("QUALIFICATION_PAIE");
    liste[0] = new Liste("categorie_qualificationlib", m0, "val", "val");
    pr.getFormu().changerEnChamp(liste);
    
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.getFormu().getChamp("id").setVisible(false);
    pr.getFormu().getChamp("matricule").setLibelle("Matricule");
    pr.getFormu().getChamp("nom").setLibelle("Nom");
    pr.getFormu().getChamp("prenom").setLibelle("Pr&eacute;nom");
    pr.getFormu().getChamp("categorie_paielib").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("categorie_qualificationlib").setLibelle("Qualification");
    pr.getFormu().getChamp("date_debut1").setLibelle("Date De D&eacute;but Min");
    pr.getFormu().getChamp("date_debut2").setLibelle("Date De D&eacute;but Max");
    pr.getFormu().getChamp("date_fin1").setLibelle("Date De Fin Min");
    pr.getFormu().getChamp("date_fin2").setLibelle("Date De Fin Max");
    pr.getFormu().getChamp("montant1").setLibelle("Montant Min");
    pr.getFormu().getChamp("montant2").setLibelle("Montant Max");
    
    
    pr.setNpp(250);
//    pr.getFormu().getChamp("dateapplication1").setLibelle("Date d'application min");
//    pr.getFormu().getChamp("dateapplication2").setLibelle("Date d'application max");
//    pr.getFormu().getChamp("idlogpers").setLibelle("Personnel");
//    pr.getFormu().getChamp("idtypedebauche").setLibelle("Cause de d&eacute;part");
    pr.setApres("paie/contrat/contrat_travail.jsp");
        
    String[] colSomme = {"montant"};
    pr.creerObjetPage(libEntete, colSomme);%>
    String[] libelles = {" ", "Nombre", "Somme de salaire" };
    pr.getTableauRecap().setLibeEntete(libelles);

<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des contrats de travail</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/contrat/contrat_travail.jsp" method="post" name="ctravail" id="ctravail">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>

        <% out.println(pr.getTableauRecap().getHtml());%>
        <br>
        
        <form action="/savonnerie/EtatReportJasper?action=contrat_travail" method="get" name="incident" id="incident">
            <input type="hidden" name="action" value="contrat_travail"/>
        <%
                String libEnteteAffiche[] =  {"Id","Matricule","Nom", "Pr&eacute;nom","Cat&eacute;gorie","Qualification", "Salaire", "Date de d&eacute;but","Date de fin","Contrat"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            
            pr.getTableau().setNameActe("contrattravail");
            pr.getTableau().setNameBoutton("Contrat de travail");
            out.println(pr.getTableau().getHtmlWithCheckbox());
            //out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
        </form>
        
    </section>
</div>
<% } catch(Exception e) { e.printStackTrace();}%>
