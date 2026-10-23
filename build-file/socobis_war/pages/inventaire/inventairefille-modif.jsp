<%@page import="bean.CGenUtil"%>
<%@page import="utilisateur.Utilisateur"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.PageInsert"%>
<%@ page import="inventaire.InventaireFille" %>

<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        InventaireFille tache = new InventaireFille();
        PageInsert pi = new PageInsert(tache, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("idProduit").setVisible(false);
        pi.getFormu().getChamp("idJauge").setVisible(false);
        pi.getFormu().getChamp("idFournisseur").setVisible(false);
        pi.getFormu().getChamp("mvtsrc").setVisible(false);
        pi.getFormu().getChamp("daty").setVisible(false);
        pi.getFormu().getChamp("quantiteTheorique").setVisible(false);
        pi.getFormu().getChamp("quantite").setVisible(false);
        pi.getFormu().getChamp("pu").setVisible(false);
        pi.getFormu().getChamp("idInventaire").setVisible(false);
        pi.getFormu().getChamp("explication").setType("explication");
        pi.preparerDataFormu();
        tache = (InventaireFille) pi.getBase();
        String idmere = tache.getIdInventaire();
        System.out.println(request.getParameter("acte"));
        System.out.println("id mere " + idmere);
%>
<div class="content-wrapper">
    <h1 align="center">explication inventaire : <%= request.getParameter("id")%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp&id=<%=request.getParameter("id")%>" method="post" >
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input type="hidden" name="acte" id="acte" value="update"/>
        <input name="bute" type="hidden" id="bute" value="inventaire/inventaire-fiche.jsp">
        <input name="nomtable" type="hidden" id="nomtable" value="InventaireFille">
        <input name="classe" type="hidden" id="classe" value="inventaire.InventaireFille">
    </form>
</div>
<%
    } catch (Exception e) {
        throw e;
    }
%>
