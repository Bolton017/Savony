<%-- 
    Document   : categoriequalification-saisie
    Created on : 30 d�c. 2020, 11:27:39
    Author     : Sanda
--%>

<%@page import="paie.CategorieQualification"%>
<%@page import="paie.categorie.SalaireCategorie"%>
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
    String titre = "Saisie d'un salaire par cat&eacute;gorie";
//    String but = "apresTarif.jsp";
    if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update"))
    {
        titre = "Modification salaire";
    }
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "paie.categorie.SalaireCategorie",
            nomtable = "CATEGORIE_QUALIFICATION",
            apres = "paie/categorie/salaireparcategorie-fiche.jsp";

    SalaireCategorie  objet = new SalaireCategorie();
    objet.setNomTable(nomtable);
    PageInsert pi = new PageInsert(objet, request, u);
    pi.setLien((String) session.getValue("lien"));

    affichage.Champ[] liste = new affichage.Champ[2];
   TypeObjet liste1 = new TypeObjet();
   liste1.setNomTable("qualification_paie");
   liste[0] = new Liste("idQualification", liste1, "val", "id");

   TypeObjet liste2 = new TypeObjet();
   liste2.setNomTable("CATEGORIE_PAIE");
   liste[1] = new Liste("idCategorie", liste2, "val", "id");

   pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("montant").setLibelle("Montant du salaire");
    pi.getFormu().getChamp("date_debut").setLibelle("Date de d&eacute;but");
    pi.getFormu().getChamp("date_debut").setDefaut(Utilitaire.dateDuJour());
    pi.getFormu().getChamp("date_fin").setLibelle("Date de fin");
    Date dateFinDuMois = Utilitaire.ajoutJourDate(Utilitaire.dateDuJour(), 365); // un an apres ny date fin
    pi.getFormu().getChamp("date_fin").setDefaut(Utilitaire.formatterDaty(dateFinDuMois));
    pi.getFormu().getChamp("idCategorie").setLibelle("Cat&eacute;gorie");
    pi.getFormu().getChamp("idQualification").setLibelle("Classification");
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
