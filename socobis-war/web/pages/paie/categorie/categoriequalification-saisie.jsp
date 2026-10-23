<%-- 
    Document   : categoriequalification-saisie
    Created on : 30 d�c. 2020, 11:27:39
    Author     : Sanda
--%>

<%@page import="paie.CategorieQualification"%>
<%@page import="paie.employe.PaieInfoPersonnel"%>
<%@page import="affichage.PageInsert"%> 
<%@page import="user.UserEJB"%> 
<%@page import="affichage.Liste"%> 
<%@page import="utilitaire.Utilitaire"%>
<%@page import="bean.TypeObjet"%>
<%@ page import="java.sql.Date" %>
<%
    try{
    String acte = "insert";
    String titre = "Saisie d'un salaire";
//    String but = "apresTarif.jsp";
    if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update"))
    {
        titre = "Modification salaire";
    }
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "paie.CategorieQualification",
            nomtable = "categorie_qualification",
            apres = "paie/categorie/categoriequalification-fiche.jsp";

    CategorieQualification  objet = new CategorieQualification();
    objet.setNomTable(nomtable);
    PageInsert pi = new PageInsert(objet, request, u);
    pi.setLien((String) session.getValue("lien"));

//    affichage.Champ[] liste = new affichage.Champ[2];
//    TypeObjet liste1 = new TypeObjet();
//    liste1.setNomTable("qualification_paie");
//    liste[0] = new Liste("idqualification", liste1, "val", "id");
//
//    String[] valeurs = {"1","0"};
//    String[] affiches = {"Avenant","Autre"};
//    liste[1] = new Liste("avenant" ,affiches,valeurs);
//    pi.getFormu().changerEnChamp(liste);
	

    String idPersonnel = request.getParameter("id");

    if (idPersonnel != null && !idPersonnel.isEmpty()) {
        pi.getFormu().getChamp("remarque").setDefaut(idPersonnel);
    }
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("remarque").setPageAppelComplete("paie.log.LogPersonnel","id","log_personnel_v2");
    pi.getFormu().getChamp("remarque").setLibelle("Personnel");
    pi.getFormu().getChamp("remarque").setAutre("readonly");
    pi.getFormu().getChamp("date_debut").setLibelle("Date de d&eacute;but");
    pi.getFormu().getChamp("date_debut").setDefaut(Utilitaire.dateDuJour());
    pi.getFormu().getChamp("date_fin").setLibelle("Date de fin");
    Date dateFinDuMois = Utilitaire.ajoutJourDate(Utilitaire.dateDuJour(), 365); // un an apres ny date fin
    pi.getFormu().getChamp("date_fin").setDefaut(Utilitaire.formatterDaty(dateFinDuMois));
    pi.getFormu().getChamp("idcategorie").setVisible(false);
    pi.getFormu().getChamp("idqualification").setVisible(false);
    pi.getFormu().getChamp("avenant").setLibelle("Avenant");
    pi.getFormu().getChamp("avenant").setDefaut("0");
    pi.getFormu().getChamp("avenant").setVisible(false);
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>
    
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="<%= acte %>">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> 
	alert('<%=e.getMessage()%>');
    history.back();</script>
<% }%>
