<%-- 
    Document   : casierarticle-saisie
    Created on : 29 d�c. 2022, 09:23:57
    Author     : Rado
--%>


<%@page import="facture.tr.Traite"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="utils.ConstanteVente" %>
<%
    try {

        Traite a = new Traite();
        a.setNomTable("traite");
        PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        affichage.Champ[] liste = new affichage.Champ[2];

        TypeObjet o = new TypeObjet();
        o.setNomTable("banque");
        liste[0] = new Liste("banque", o, "VAL", "id");
        TypeObjet obj = new TypeObjet();
        obj.setNomTable("type_piece");
        liste[1] = new Liste("idtypepiece",obj,"desce","id");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("tiers").setPageAppelComplete("client.Client","id","Client");
        //pi.getFormu().getChamp("tiers").setAutre("readonly");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idtypepiece").setLibelle("Type");
        pi.getFormu().getChamp("idtypepiece").setDefaut(ConstanteVente.typepiecetraire);
        pi.getFormu().getChamp("dateEcheance").setLibelle("Date d'&eacute;ch&eacute;ance");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idfinaledestination").setVisible(false);
        pi.getFormu().getChamp("numcheque").setLibelle("Num&eacute;ro de ch&egrave;que");
        pi.getFormu().getChamp("numpiece").setLibelle("Num&eacute;ro de Pi&egrave;ce");
        pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pi.preparerDataFormu();
         String titre = "Saisie d'une traite";
        if(request.getParameter("acte")!=null){
            titre = "Modification d'une traite";
        }   
%>
<div class="content-wrapper">
    <h1><%= titre %></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" data-parsley-validate>
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="facture/traite-fiche.jsp">
        <input name="classe" type="hidden" id="classe" value="facture.tr.Traite">
        <input name="nomtable" type="hidden" id="classe" value="traite">
    </form>
</div>

<%} catch (Exception e) {
    e.printStackTrace();
}%>