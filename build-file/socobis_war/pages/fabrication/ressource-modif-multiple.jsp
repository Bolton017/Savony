<%@page import="user.*"%>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@ page import="fabrication.*" %>
<%@ page import="utilitaire.Utilitaire" %>
<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = u = (UserEJB) session.getValue("u");

        String classeMere = "fabrication.Fabrication";
        String classeFille = "fabrication.RessourceParFabrication";
        String colonneMere = "idFabrication";
        String redirection = "fabrication/fabrication-fiche.jsp&id="+request.getParameter("id")+"&tab=inc/fabrication-ressource";
        String titre = "Modification Ressource Multiple";
        String nomtable = "ressourceparfabrication";
        Fabrication mere = new Fabrication();
        RessourceParFabrication fille = new RessourceParFabrication();
        fille.setNomTable(nomtable);
        fille.setIdFabrication(request.getParameter("id"));

        RessourceParFabrication[] details = (RessourceParFabrication[]) CGenUtil.rechercher(fille, null, null, "");
        PageUpdateMultiple pi = new PageUpdateMultiple(mere, fille, details, request, (user.UserEJB) session.getValue("u"), details.length);
        pi.setLien((String) session.getValue("lien"));

        pi.getFormufle().getChamp("idFabrication_0").setLibelle("Fabrication");
        pi.getFormufle().getChamp("idRessource_0").setLibelle("Ressource");
        pi.getFormufle().getChamp("idQualification_0").setLibelle("Classification");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("idPoste_0").setLibelle("Poste");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("idPoste"),"readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("idQualification"),"readonly");
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("etat"),false);
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idFabrication"),"fabrication.Fabrication","id","FABRICATIONCPL","","");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idRessource").getListeChamp(), "personnel.Personnel","id","PERSONNEL", "","");

        pi.preparerDataFormu();

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<div class="content-wrapper">
    <h1><%=titre%></h1>
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp&id=<%out.print(request.getParameter("id"));%>" method="post" >
        <div style="text-align: center;">
        </div>
        <%
            pi.getFormufle().makeHtmlInsertTableauIndex();
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="updateInsert">
        <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=details.length%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomtable %>">
    </form>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
