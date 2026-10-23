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
    String nomTable = "paie_info_perso_histo_avenants";

    if (request.getParameter("table") != null && request.getParameter("table").compareToIgnoreCase("") != 0) {
            nomTable = request.getParameter("table");
    }
    dr.setNomTable(nomTable);
     
    String listeCrt[] = {"id","matricule","nom","prenom","categorie_paielib","categorie_qualificationlib"};
    String listeInt[] = {""};
    String libEntete[] = {"id","matricule","nom","prenom","categorie_paielib","categorie_qualificationlib","montant","date_debut","date_fin","avenant"};
    
    PageRecherche pr = new PageRecherche(dr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
//    pr.getFormu().getChamp("id").setVisible(false);
    pr.getFormu().getChamp("matricule").setLibelle("Matricule");
    pr.getFormu().getChamp("nom").setLibelle("Nom");
    pr.getFormu().getChamp("prenom").setLibelle("Pr&eacute;nom");
    pr.getFormu().getChamp("categorie_paielib").setLibelle("Categorie");
    pr.getFormu().getChamp("categorie_qualificationlib").setLibelle("Qualification");
    pr.setNpp(250);
//    pr.getFormu().getChamp("dateapplication1").setLibelle("Date d'application min");
//    pr.getFormu().getChamp("dateapplication2").setLibelle("Date d'application max");
//    pr.getFormu().getChamp("idlogpers").setLibelle("Personnel");
//    pr.getFormu().getChamp("idtypedebauche").setLibelle("Cause de d&eacute;part");
    pr.setApres("paie/contrat/contrat_travail.jsp");
        
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste Contrat Travail Avenant</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/contrat/contrat_travail_avenant.jsp" method="post" name="ctravail" id="ctravail">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>

        <% out.println(pr.getTableauRecap().getHtml());%>
        <br>
        
        <form action="/fer/EtatReportJasper?action=contrat_travail_avenant" method="get" name="incident" id="incident">
            <input type="hidden" name="action" value="contrat_travail_avenant"/>
        <%
            String libEnteteAffiche[] =  {"Id","Matricule","Nom", "Pr&eacute;nom","Categorie","Qualification", "Salaire", "Date debut","Date fin","Contrat"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            
            pr.getTableau().setNameActe("contrattravail");
            pr.getTableau().setNameBoutton("Avenant");
            
           
        %>
        <%
            if (pr.getTableau().getHtmlWithCheckbox() != null) {
                out.println(pr.getTableau().getHtmlWithCheckbox());
            }
             //out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());

        %>
        </form>
        
    </section>
</div>
<% } catch(Exception e) { e.printStackTrace();}%>
