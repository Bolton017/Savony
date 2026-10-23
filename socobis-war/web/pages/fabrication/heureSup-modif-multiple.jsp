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
        String classeFille = "fabrication.HeureSupFabrication";
        String colonneMere = "idFabrication";
        String redirection = "fabrication/fabrication-fiche.jsp";
        String titre = "Modification Heure Suppl&eacute;mentaire Multiple";

        Fabrication mere = new Fabrication();
        HeureSupFabrication fille = new HeureSupFabrication();
        fille.setNomTable("heureSupFabrication_cpl");
        fille.setIdFabrication(request.getParameter("id"));

        HeureSupFabrication[] details = (HeureSupFabrication[]) CGenUtil.rechercher(fille, null, null, "");
        PageUpdateMultiple pi = new PageUpdateMultiple(mere, fille, details, request, (user.UserEJB) session.getValue("u"), details.length);
        pi.setLien((String) session.getValue("lien"));

        pi.getFormufle().getChamp("idRessParFab_0").setLibelle("Ressource Fabrication");
        pi.getFormufle().getChamp("heurenormale_0").setLibelle("Heure Normale");
        pi.getFormufle().getChamp("HS_0").setLibelle("Heure Suppl&eacute;mentaire");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Personnel");
        pi.getFormufle().getChamp("MN_0").setLibelle("Majoration Nuit");
        pi.getFormufle().getChamp("JF_0").setLibelle("Jour Feri&eacute;");
        pi.getFormufle().getChamp("IF_0").setLibelle("Indemnit&eacute; de fonction");
        pi.getFormufle().getChamp("HD_0").setLibelle("Heure Dimanche");

        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("temporaire").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idFabrication").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idPersonne").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("etat").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("tauxHoraire").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("tauxHoraireEffective").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("matricule").getListeChamp(),false);

        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("idRessParFab").getListeChamp(),"readonly");

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
        <input name="nomtable" type="hidden" id="nomtable" value="heureSupFabrication">
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
