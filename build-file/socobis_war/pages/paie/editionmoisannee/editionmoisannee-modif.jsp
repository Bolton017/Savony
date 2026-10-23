<%--
    Document   : editionmoisannee-modif
    Created on : 15 d�c. 2021, 10:30:42
    Author     : rijan
--%>

<%@page import="utilitaire.Constante"%>
<%@page import="bean.TypeObjet"%>
<%@page import="bean.CGenUtil"%>
<%@page import="utilisateur.Role"%>
<%@page import="utilitaire.Utilitaire"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>
<%@ page import="paie.edition.PaieEditionmoisanneeLib" %>
<%
    try{
        PaieEditionmoisanneeLib paieedition = new PaieEditionmoisanneeLib();
        PageUpdate pc = new PageUpdate(paieedition, request, (user.UserEJB) session.getValue("u"));
        pc.setLien((String) session.getValue("lien"));

        pc.getFormu().getChamp("idpersonnel").setAutre("readonly");
        pc.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
        pc.getFormu().getChamp("iddirection").setAutre("readonly");

        pc.getFormu().getChamp("iddirection").setLibelle("Direction");
        pc.getFormu().getChamp("daty").setLibelle("Date");
        pc.getFormu().getChamp("iduser").setAutre("readonly");
        pc.getFormu().getChamp("mois").setAutre("readonly");
        pc.getFormu().getChamp("mois_string").setAutre("readonly");
        pc.getFormu().getChamp("mois_string").setLibelle("Mois");
        pc.getFormu().getChamp("montant").setAutre("readonly");
        pc.getFormu().getChamp("gain").setAutre("readonly");
        pc.getFormu().getChamp("retenue").setAutre("readonly");
        pc.getFormu().getChamp("etat").setVisible(false);
        pc.getFormu().getChamp("id").setVisible(false);

        pc.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1>Modification Edition Mois Ann&eacute;e</h1>
    <form action="<%=pc.getLien()%>?but=apresTarif.jsp" method="post" name="paieedition" id="paieedition">
        <%
            pc.getFormu().makeHtmlInsertTabIndex();
            out.println(pc.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="update">
        <input name="bute" type="hidden" id="bute" value="paie/editionmoisannee/editionmoisannee-fiche.jsp">
        <input name="nomtable" type="hidden" id="nomtable" value="paie_editionmoisannee">
        <input name="classe" type="hidden" id="classe" value="paie.edition.PaieEditionmoisanneeLib">
    </form>
</div>
<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>
